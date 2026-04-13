#!/bin/bash

mklink() {
    local src="$1"
    local dest="$2"

    # If the symlink already exists, delete it so we can re-set it properly.
    if [[ -L "$dest" ]]; then
        rm "$dest"
    fi
    ln -sf "$src" "$dest"
}
