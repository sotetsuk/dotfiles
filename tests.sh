#!/usr/bin/env zsh

source ~/.zshrc

set -e

# Installed w/ package manager
which git
which vim
which curl
# which wget
# which tree
which tmux
which python3
which pip3
# which bat
# which xz
# which unxz
# which gh
# which pre-commit
# which xsel

# Installed w/o package manager
which fzf
which poetry
which imgcat
which imgls
which it2dl
which it2ul

# Original commands
which tmx

echo "-------------------------------"
echo "All tests passed!"
echo "-------------------------------"
