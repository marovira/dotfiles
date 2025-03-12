# OSX Installation

Download and install [homebrew](https://docs.brew.sh/Installation). Once that is done,
follow the same installation instructions for [linux](INSTALL_LINUX.md).

Exception to the rule is `wezterm`, which can be installed directly through homebrew as
follows:

```sh
brew install --cask wezterm
```

> [!CAUTION]
> As of now, tmux will crash on start. I haven't been able to figure out why this happens,
> but it may just resolve itself eventually. The current workaround is to just use Wezterm
> instead.
