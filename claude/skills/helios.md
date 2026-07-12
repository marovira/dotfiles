# Helios Skill

Reference for working with the Helios PyTorch training framework (`src/helios/`). Read
this before writing any Helios training code.

---

## The three core abstractions

Every Helios training run wires together exactly three objects:

| Class | Module | Purpose |
|---|---|---|
| `Model` | `helios.model` | training/validation/testing logic |
| `DataModule` | `helios.data` | dataset and dataloader creation |
| `Trainer` | `helios.trainer` | orchestrates the loop, checkpointing, distributed setup |

The user subclasses `Model` and `DataModule`, constructs a `Trainer`, then calls
`trainer.fit(model, datamodule)` or `trainer.test(model, datamodule)`.

---

## Model

### Mandatory override

```python
import helios.model as hlm

class MyModel(hlm.Model):
    def setup(self, for_inference: bool = False) -> None:
        self._net = ...
        self._optimizer = ...
        if not for_inference:
            self._scheduler = ...
```

`setup()` is called after distributed processes are launched and after the device is
assigned. `self.device`, `self.is_distributed`, and `self.trainer` are all populated
before `setup()` runs. The `for_inference` flag is `True` during `test()` runs — skip
optimisers and schedulers in that branch.

### Step callbacks

Override whichever steps you need. The trainer calls them in this order per batch:

**Training:** `on_training_batch_start` → `train_step` → `on_training_batch_end`

**Validation:** `on_validation_start` → `on_validation_batch_start` → `valid_step` →
`on_validation_batch_end` → `on_validation_end`

**Testing:** `on_testing_start` → `on_testing_batch_start` → `test_step` →
`on_testing_batch_end` → `on_testing_end`

```python
def train_step(self, batch: typing.Any, state: hlm.TrainingState) -> None:
    # batch has already been moved to self.device via batch_to_device()
    inputs, labels = batch
    self._optimizer.zero_grad()
    loss = self._criterion(self._net(inputs), labels)
    self._loss_items["loss"] = loss   # stored for on_training_batch_end
    loss.backward()
    self._optimizer.step()

def valid_step(self, batch: typing.Any, step: int) -> None:
    inputs, labels = batch
    with torch.no_grad():
        preds = self._net(inputs)
    self._val_scores[step] = compute_metric(preds, labels)
```

### train() and eval() are intentional no-ops

You **must** override them and call `.train()` / `.eval()` on your own networks:

```python
def train(self) -> None:
    self._net.train()

def eval(self) -> None:
    self._net.eval()
```

### batch_to_device

The default recursively moves any `torch.Tensor` in the batch to `self.device`. Override
only when you need custom logic. Use the `phase` argument (`BatchPhase.TRAIN`,
`BatchPhase.VALID`, `BatchPhase.TEST`) to differentiate.

### Checkpointing

```python
def user_state_dict(self) -> dict[str, typing.Any]:
    return {
        "net": self._net.state_dict(),
        "optimizer": self._optimizer.state_dict(),
    }

def load_user_state_dict(
    self, state_dict: dict[str, typing.Any], for_inference: bool
) -> None:
    self._net.load_state_dict(state_dict["net"])
    if not for_inference:
        self._optimizer.load_state_dict(state_dict["optimizer"])
```

- `user_state_dict()` / `load_user_state_dict()` are the only methods you touch; the
  trainer wraps them in the outer checkpoint format automatically.
- Key names inside `user_state_dict()` are entirely up to you — no reserved strings.
- `trained_state_dict()` is separate and used for saving the final artefact (not
  checkpoints).

### Save-best logic

```python
def should_save_checkpoint(self) -> bool:
    return self._val_score > self._best_score

def on_validation_end(self, validation_cycle: int) -> None:
    super().on_validation_end(validation_cycle)   # clears _running_losses
    self._val_score = compute_final_metric(self._val_scores)
```

### AMP (Automatic Mixed Precision)

```python
def setup(self, for_inference: bool = False) -> None:
    self._net = ...
    self._optimizer = ...
    self.create_scaler()           # float16 by default; pass dtype=torch.bfloat16 for CPU

def train_step(self, batch, state):
    self._optimizer.zero_grad()
    with self.autocast():
        loss = self._criterion(self._net(inputs), labels)
    self._loss_items["loss"] = loss
    scaler = self.amp_context.scaler
    scaler.scale(loss).backward()
    self.clip_gradients(self._net.parameters(), self._optimizer, max_norm=1.0)
    scaler.step(self._optimizer)
    scaler.update()
```

`autocast()` returns a null context when AMP is disabled, so the same code works with
and without AMP. `clip_gradients()` handles `unscale_()` automatically before clipping.
CPU AMP supports only `bfloat16`.

### Scheduler initialisation

Call `self.get_train_steps_per_epoch()` inside `setup()` to get the epoch length before
constructing schedulers that need it. The result delegates to
`self.trainer.datamodule.get_train_steps_per_epoch()`.

### Custom checkpoint filename metadata

```python
def append_metadata_to_chkpt_name(self, chkpt_name: str) -> str:
    return f"{chkpt_name}_acc_{self._best_acc:.4f}"
```

### Early stopping

```python
def have_metrics_improved(self) -> bool:
    return self._val_score > self._best_score

def should_training_stop(self) -> bool:
    return self._loss_is_nan
```

### Multi-phase training

```python
def should_advance_dataset_phase(self) -> bool:
    if not self._phase_advanced and self._current_epoch >= 10:
        self._phase_advanced = True
        return True
    return False
```

This must return `True` only once per transition. The trainer calls
`datamodule.advance_train_phase()` automatically when it returns `True`.

### Extra safe globals for checkpointing

```python
def types_for_safe_load(self) -> list:
    return [MyCustomEnum]
```

---

## DataModule

### Mandatory override

```python
import helios.data as hld

class MyDataModule(hld.DataModule):
    def setup(self) -> None:
        params = hld.DataLoaderParams(batch_size=32, shuffle=True, num_workers=4)
        self._add_train_phase(MyTrainDataset(...), params)
        self._add_valid_dataset(MyValidDataset(...), hld.DataLoaderParams(batch_size=32))
        self._add_test_dataset(MyTestDataset(...), hld.DataLoaderParams(batch_size=1))
```

- Call `_add_train_phase()` once per training phase; the first call sets
  `self._train_dataset` automatically.
- For validation and test use `_add_valid_dataset()` and `_add_test_dataset()`.
- `DataLoaderParams` accepts a `dict` too: `_add_valid_dataset(ds, {"batch_size": 32})`.

### prepare_data

```python
def prepare_data(self) -> None:
    MyDataset.download()   # runs on the primary process only, before spawning
```

Do not set instance state here — it runs on a different process when distributed.

### DataLoaderParams defaults

`pin_memory` defaults to `False`. GPU users must opt in explicitly.
`is_distributed` defaults to `None`, which lets Helios fill it in from the trainer.

### Teardown

```python
def teardown(self) -> None:
    self._cache.clear()
```

Called after `fit()` or `test()` completes.

---

## Trainer

### Minimal example

```python
import pathlib
import helios

trainer = helios.Trainer(
    run_name="my_run",
    train_unit=helios.TrainingUnit.EPOCH,
    total_steps=100,
    valid_frequency=5,
    chkpt_frequency=10,
    chkpt_root=pathlib.Path("checkpoints"),
    log_root=pathlib.Path("logs"),
    enable_file_logging=True,
    enable_progress_bar=True,
)
trainer.fit(MyModel("my_model"), MyDataModule())
```

### Key constructor parameters

| Parameter | Type | Notes |
|---|---|---|
| `train_unit` | `TrainingUnit` or `"epoch"`/`"iteration"` | controls loop unit |
| `total_steps` | `int` or `float("inf")` | number of epochs or iterations |
| `valid_frequency` | `int \| None` | validate every N steps; `None` disables |
| `chkpt_frequency` | `int \| None` | save every N steps; `None` disables |
| `print_frequency` | `int \| None` | triggers `should_log=True` in `on_training_batch_end` |
| `accumulation_steps` | `int` | gradient accumulation; default 1 |
| `early_stop_cycles` | `int \| None` | stop after N non-improving validation cycles |
| `log_root` | `pathlib.Path \| None` | required when file/Tensorboard/W&B logging is on |
| `chkpt_root` | `pathlib.Path \| None` | checkpoints saved under `chkpt_root/<model.save_name>/` |
| `wandb_args` | `WandbArgs \| None` | enables W&B; requires `log_root` |
| `src_root` | `pathlib.Path \| None` | scans the directory and auto-populates registries |
| `gpus` | `list[int] \| None` | explicit GPU IDs; `None` uses all available |
| `use_cpu` | `bool \| None` | `None` auto-detects; `True` forces CPU |
| `enable_deterministic` | `bool` | mutually exclusive with `enable_cudnn_benchmark` |

### Checkpoint auto-resumption

`Trainer.fit()` automatically finds and loads the last checkpoint from `chkpt_root`
using `find_last_checkpoint()`. Checkpoint filenames must contain `epoch_<N>_iter_<N>`.

To load a checkpoint manually (e.g. for inference):

```python
import helios
helios.register_trainer_types_for_safe_load()
state = helios.core.safe_torch_load(path)
```

### GPU / distributed

Single GPU — pass `gpus=[0]`.

Multi-GPU (DDP via `mp.spawn`) — pass `gpus=[0, 1, 2, 3]`.

`torchrun` — detected automatically; just run `torchrun --nproc_per_node=4 train.py`.

Use `dist.is_primary_rank()` to guard rank-0-only operations inside `Model` callbacks.

### W&B logging

```python
from helios.core import loggers

trainer = helios.Trainer(
    ...,
    log_root=pathlib.Path("logs"),
    wandb_args=loggers.WandbArgs(
        project="my-project",
        name="run-001",
        config={"lr": 1e-3},
    ),
)
```

### Plugins

```python
trainer.register_plugin(MyPlugin("my_plugin_id"))
```

`configure_trainer()` and `configure_model()` are called automatically before
training/testing. At most one plugin may override each `UniquePluginOverrides` field
(`training_batch`, `validation_batch`, `testing_batch`, `should_training_stop`).

---

## Registry pattern

Registries map string names to types. Use them when you want to construct objects by
name (e.g. from a config file).

```python
import helios.data as hld
import helios.model as hlm

@hld.DATASET_REGISTRY.register
class MyDataset(torch.utils.data.Dataset): ...

@hlm.MODEL_REGISTRY.register
class MyModel(hlm.Model): ...

# Create from registry
dataset = hld.DATASET_REGISTRY.get("MyDataset")(...)
```

Available registries: `DATASET_REGISTRY`, `COLLATE_FN_REGISTRY`, `TRANSFORM_REGISTRY`
(data); `MODEL_REGISTRY` (model); `PLUGIN_REGISTRY` (plugins); `LOSS_REGISTRY` (losses);
`OPTIMIZER_REGISTRY` (optim); `SCHEDULER_REGISTRY` (scheduler).

To auto-populate registries from a source tree, pass `src_root` to `Trainer` or call
`helios.core.update_all_registries(src_root, recurse=True, import_prefix="mypackage")`.

---

## Scheduler helpers

`LinearWarmupScheduler` wraps any scheduler with a linear warmup phase:

```python
import helios.scheduler as hls

scheduler = hls.LinearWarmupScheduler(
    optimizer=self._optimizer,
    warmup_steps=500,
    scheduler=torch.optim.lr_scheduler.CosineAnnealingLR(self._optimizer, T_max=10000),
    warmup_start_factor=0.0,
)
```

---

## Metrics

Five functional metrics and `nn.Module` wrappers in `helios.metrics`:

```python
import helios.metrics as hlme

acc = hlme.calculate_accuracy(preds, targets, top_k=1)
precision = hlme.calculate_precision(preds, targets)
recall = hlme.calculate_recall(preds, targets)
f1 = hlme.calculate_f1(preds, targets)
rmse = hlme.calculate_rmse(preds, targets)
```

---

## TrainingState fields

Available as `state` in `train_step()` and `on_training_batch_end()`:

| Field | Meaning |
|---|---|
| `current_iteration` | gradient-update count (accounts for accumulation) |
| `global_iteration` | raw forward-pass count |
| `global_epoch` | epoch count |
| `validation_cycles` | number of completed validation cycles |
| `dataset_iter` | batch index within the current epoch (reset each epoch) |
| `running_iter` | iteration count since the last validation cycle |
| `average_iter_time` | exponential average time per iteration (seconds) |
| `early_stop_count` | consecutive non-improving validation cycles |

---

## Common pitfalls

- **`train()` and `eval()` are no-ops.** If you forget to override them your network
  never switches modes and batch-norm / dropout behave incorrectly during validation.
- **`pin_memory` is `False` by default.** Set it explicitly in `DataLoaderParams` for
  GPU training.
- **`batch_to_device()` handles the device transfer.** Do not call `.to(device)` inside
  `train_step()`; the batch is already on the correct device.
- **`prepare_data()` must not set instance state.** It runs on the main process before
  distributed workers are spawned; any state set there is invisible to the workers.
- **`log_root` is required** whenever `enable_file_logging`, `enable_tensorboard`, or
  `wandb_args` is set — the trainer raises `ValueError` otherwise.
- **`should_advance_dataset_phase()` must return `True` exactly once per phase
  transition.** Track the advance with a flag; returning `True` repeatedly causes the
  trainer to rebuild the dataloader on every step.
- **Checkpoint filenames must follow the `epoch_<N>_iter_<N>` pattern** for
  `find_last_checkpoint()` to discover them.
- **`enable_deterministic` and `enable_cudnn_benchmark` are mutually exclusive.** The
  trainer raises `ValueError` if both are set.
- **CPU AMP only supports `bfloat16`.** Passing any other dtype raises `ValueError`.
