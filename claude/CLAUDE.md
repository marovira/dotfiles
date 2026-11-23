# Commit policy

Commit your work as you go, without waiting for approval. `git push` is denied in
settings, so commits stay local until the user reviews and pushes them.

- Make small, focused commits: one logical change each. If the project defines a
  definition of done, meet it before committing.
- Stage files by name. Do not use `git add -A` or `git add .`, so that scratch files and
  unrelated changes stay out.
- Leave changes that were already in the working tree when you started out of your
  commits, unless the user asks you to include them.
- Only amend commits you created in the current task. Never rewrite the user's commits.

## Commit messages

Linters enforce the format (prefix, case, mood, line length). This section covers
content. Check `git log` for repository-specific conventions, such as subject prefixes
or tags.

**Subject:** name the concrete change and what it touches, for example "Rename fast_init
to for_inference". For a fix, name the bug, not the edit: "Fix a panic when
msvc-toolset is set on non-Windows platforms". Generic subjects such as "Update docs" or
"Bump patch version" are fine only for routine chores.

**Body:** the body records what the diff cannot show: why the change was made. Leave it
out when the subject is enough. Most bodies are one paragraph of two to five sentences.
Write more only when the reasoning needs it, such as a subtle bug or a multi-step plan.
Cover what applies:

- Why: the motivation, or the problem being solved.
- For a bug: when it happens and why. Then describe the fix in one sentence, as an
  idea ("re-throw the exception if the loggers aren't configured"), not as code.
- Deliberate decisions: a choice the reader might question, with its reason or its
  known risk.
- Consequences the reader must act on, such as a breaking change, a new minimum version,
  or an invalidated cache, in one sentence starting with "Note that", at the end.
- Follow-up work, when the commit is one step of a larger plan.

Describe the change at the level a reviewer would discuss it. Naming the identifier the
change is about is fine. Leave out the implementation (helper names, signatures,
constants, how detection works), because the diff shows it. Mention a secondary change
only if it is a change in its own right, in a closing "We also..." sentence. Skip
incidental cleanups such as an added `explicit` or an extracted helper.

If tests were added, say so in one clause. Do not describe what they check.

Write in plain prose, using "we" rather than "I". Use a list only for several
independent changes or reasons.

Do not invent a motivation. If the reason is not evident from the task or the code,
describe what the change does and stop.

# Scratch files

`rm` is denied in settings, so Claude cannot clean up scratch files (test programs,
experiments, captured output). Put them somewhere that cleans itself up or that git
ignores:

- **Unix:** use `/tmp` for throwaway files that can be cleared on reboot. Use `/var/tmp`
  only for files that must survive a reboot. Prefer `/tmp` unless strictly necessary.
- **Windows:** there is no automatic cleanup, so use a directory that is gitignored, such
  as `build/` or `.scratch/`. Check `.gitignore` for an option. If there is no obvious
  one, ask where to put them instead of editing `.gitignore` or choosing a location.
  - Reuse and overwrite a small set of file names instead of creating a new file per
    experiment, since nothing can be deleted.
  - Never stage scratch files.
