#!/bin/bash

set -e

branch="${1:-master}" # Default to master if no branch is explicitly given.
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source $script_dir/install_pacman.sh

# Install necessary apps
pacman -S zsh util-linux pv tree

# Set system-wide git configs
git config --system core.autocrlf input
git config --system init.defaultBranch $branch
