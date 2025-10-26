# OSX Installation

Download and install [homebrew](https://docs.brew.sh/Installation). Once that is done,
follow the same installation instructions for [linux](INSTALL_LINUX.md).

Exception to the rule is `wezterm`, which can be installed directly through homebrew as
follows:

```sh
brew install --cask wezterm
```

> [!IMPORTANT]
> Do not install `tmux`. There's an issue where it crashes on start.
