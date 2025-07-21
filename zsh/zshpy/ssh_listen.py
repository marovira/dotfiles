import argparse
import json
import os
import pathlib
import subprocess


def execute_command(proc_name: str, args: list[str]) -> subprocess.CompletedProcess[str]:
    env = os.environ.copy()
    kwargs = {
        "env": env,
        "encoding": "utf-8",
        "stdout": subprocess.PIPE,
        "stderr": subprocess.PIPE,
    }
    res = subprocess.run(args, **kwargs)  # type: ignore[call-overload]
    return res


def generate_sample() -> None:
    out_file = pathlib.Path.cwd() / "sample.json"

    entries: list[dict[str, str]] = []
    entries.append({"port": "localhost:16066:localhost:6006", "host": "foo@bar"})

    with out_file.open("w", encoding="utf-8", newline="\n") as outfile:
        json.dump(entries, outfile, indent=4)


def start_ssh_listeners(config: pathlib.Path) -> None:
    with config.open("r", encoding="utf-8") as infile:
        entries = json.load(infile)

    proc_name = "ssh"
    base_args = [proc_name, "-N", "-f", "-L"]
    for entry in entries:
        args = base_args.copy()
        args.append(entry["port"])
        args.append(entry["host"])

        proc = execute_command(proc_name, args)
        if proc.returncode != 0:
            print(f"error: unable to listen to {entry['host']}")
            print(proc.stderr)


parser = argparse.ArgumentParser(
    description="Start a set of ssh processes to listen at specific ports"
)
parser.add_argument(
    "table",
    metavar="TABLE",
    nargs="?",
    type=str,
    help="Path to the JSON file to use",
)
parser.add_argument(
    "-g", "--generate", action="store_true", help="Generate a sample JSON table"
)

args = parser.parse_args()

if args.table:
    config = pathlib.Path(args.table).resolve()
    start_ssh_listeners(config)
elif args.generate:
    generate_sample()
