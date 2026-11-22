# Commit policy

Commit your work as you go, without waiting for approval. `git push` is denied in
settings, so commits stay local until the user reviews and pushes them.

- Make small, focused commits: one logical change each. If the project defines a
  definition of done, meet it before committing.
- Stage files by name. Do not use `git add -A` or `git add .`, so that scratch files and
  unrelated changes stay out.
- Leave changes that were already in the working tree when you started out of your
  commits, unless the user asks you to include them.
- Follow the repository's commit message convention (check `git log`). If it has none,
  use a short imperative subject line and a body that explains why.
- Only amend commits you created in the current task. Never rewrite the user's commits.

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
