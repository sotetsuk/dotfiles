#!/usr/bin/env zsh

source ~/.zshrc

set -e

# Installed w/ package manager
which git
which vim
which curl
which wget
which tree
which tmux
which python3
which pip3
which bat
which xz
which gh
which xsel
which pygmentize

# Installed w/o package manager
which uv
which fzf
which imgcat
which it2dl
which it2ul

# Original commands
which tmx

echo "-------------------------------"
echo "All tests passed!"
echo "-------------------------------"
