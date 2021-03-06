#! /bin/bash

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
echo "# Brew install"
echo "#############################################################################"

which brew

# xz is required to install clangd language server in vim-lsp-settings
brew install \
    git \
    git-lfs	\
    vim	\
    curl \
    wget \
    tree \
    tmux \
    zsh	\
    bat	\
    xz \
    pre-commit \
    gh \
    pre-commit

echo "#############################################################################"
echo "# zsh"
echo "#############################################################################"

# make zsh as default
if [[ -z $(echo ${SHELL} | grep zsh) ]]; then 
    chsh -s $(which zsh); 
fi
# install oh my zsh.
if [[ ! -e ~/.oh-my-zsh ]]; then 
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
# if .zshrc exists and the last line does not include .zshrc.common, include it
touch ~/.zshrc
if [[ -z $(cat ~/.zshrc | grep "source ~/.zshrc.common") ]];  then
    echo "" >> ~/.zshrc;
    echo "# Automatically added" >> ~/.zshrc;
    echo "source ~/.zshrc.common" >> ~/.zshrc; 
fi 

echo "#############################################################################"
echo "# pyenv"
echo "#############################################################################"

if [[ ! -e ~/.pyenv ]]; then
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv
fi

echo "#############################################################################"
echo "# fzf"
echo "#############################################################################"

if [[ ! -e ~/.fzf ]]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all --key-bindings --completion --update-rc
fi

echo "#############################################################################"
echo "# iterm2 utilities"
echo "#############################################################################"
# https://iterm2.com/documentation-utilities.html

for fname in imgcat imgls it2dl it2ul; do
    curl -o ${HOME}/.local/bin/${fname} -O https://iterm2.com/utilities/${fname} && chmod +x ${HOME}/.local/bin/${fname}
done
