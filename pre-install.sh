#!/bin/bash
set -eu

# on ubuntu
OS="$(uname)"
if [[ "${OS}" == "Linux" ]]; then
    sudo apt update -y && sudo apt install -y build-essential git curl python3-venv python3-pip
fi


# zsh
if command -v zsh 1>/dev/null 2>&1; then
  echo "passed [zsh]"
else  # now, mac default shell is zsh
  # TODO: remove sudo
  # install zsh
  sudo apt update
  sudo apt install -y zsh
fi

# NOTE: you may need to change the default shell by `chsh -s $(which zsh)`
