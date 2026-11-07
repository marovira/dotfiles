# Commit policy

`git commit` is denied in settings, so never run it and never offer to. Use this
workflow instead:

1. Finish the change, including the project's definition of done if it defines one.
2. Present the work for review and apply any requested changes.
3. Once the user approves, stage the files with `git add` (naming files explicitly, not
   `git add -A`) and stop.
4. Tell the user the files are staged. The user writes the commit message and commits.

Do not stage anything before approval. If the user asks for a suggested commit message,
provide one, but do not run the commit.

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
