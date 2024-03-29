#! /bin/bash
set -eu

echo "#############################################################################"
echo "# Check requirements"
echo "#############################################################################"

which git &>/dev/null
which curl &>/dev/null
echo "ok"

echo "#############################################################################"
echo "# zsh"
echo "#############################################################################"

./installers/install_zsh.sh

echo "#############################################################################"
echo "# Set dotfiles"
echo "#############################################################################"

dotfiles="
.vimrc
.gitconfig
.ideavimrc
.tmux.conf
.zshrc.common
.local/bin/tmx
.local/bin/tmux-git-curr-branch
.local/bin/tmux-git-status
"

mkdir -p ~/.local/bin
for dotfile in ${dotfiles}; do
    ln -sfnv $(pwd)/${dotfile} ~/${dotfile}
done

echo "#############################################################################"
echo "# fzf"
echo "#############################################################################"

if [[ ! -e ~/.fzf ]]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all --key-bindings --completion --update-rc
else
    echo "passed [fzf]"
fi

echo "#############################################################################"
echo "# poetry"
echo "#############################################################################"
if command -v poetry 1>/dev/null 2>&1; then
    echo "passed [poetry]"
else
    curl -sSL https://install.python-poetry.org | python3 -
fi

echo "#############################################################################"
echo "# iterm2 utilities"
echo "#############################################################################"
# https://iterm2.com/documentation-utilities.html

for fname in imgcat imgls it2dl it2ul; do
  if [[ -e ${HOME}/.local/bin/${fname} ]]; then
    echo "passed [${fname}]"
    continue
  fi
  curl -o ${HOME}/.local/bin/${fname} -O https://iterm2.com/utilities/${fname} && chmod +x ${HOME}/.local/bin/${fname}
done

echo "#############################################################################"
echo "# .zshrc"
echo "#############################################################################"

# if .zshrc exists and the last line does not include .zshrc.common, include it
touch ~/.zshrc
if [[ -z $(cat ~/.zshrc | grep "source ~/.zshrc.common") ]];  then
    echo "" >> ~/.zshrc;
    echo "# Automatically added" >> ~/.zshrc;
    echo "source ~/.zshrc.common" >> ~/.zshrc; 
else
    echo "passed [.zshrc]"
fi 

echo "#############################################################################"
echo "# vim-lsp"
echo "#############################################################################"

./installers/install_vim_lsp.sh
