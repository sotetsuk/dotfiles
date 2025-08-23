#! /bin/bash
set -eu

echo "#############################################################################"
echo "# Check requirements"
echo "#############################################################################"

which git &>/dev/null
which curl &>/dev/null
which zsh &>/dev/null
echo "ok"

echo "#############################################################################"
echo "# oh-my-zsh"
echo "#############################################################################"

# install oh my zsh.
if [[ ! -e ~/.oh-my-zsh ]]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "passed [oh-my-zsh]"
fi

echo "#############################################################################"
echo "# brew"
echo "#############################################################################"

# install brew if not found
if command -v brew 1>/dev/null 2>&1; then
  echo "passed [brew]"
else
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if [[ -e "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zshrc
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
fi

# install packages using brew
# * xz is required to install clangd language server in vim-lsp-settings
# * ripgrep is required by kickstart.nvim
# * node is required by copilot
brew install tmux gh bat xz xsel tree pygments wget aichat neovim ripgrep node zoxide diff-so-fancy 2>/dev/null

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
.local/bin/p
.local/bin/i
.local/bin/jiggle
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
echo "# iterm2 utilities"
echo "#############################################################################"
# https://iterm2.com/documentation-utilities.html

for fname in imgcat it2dl it2ul; do
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
echo "# uv"
echo "#############################################################################"

if command -v uv 1>/dev/null 2>&1; then
  echo "passed [uv]"
else  # now, mac default shell is zsh
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi

echo "#############################################################################"
echo "# nvim"
echo "#############################################################################"

git submodule update --init
mkdir -p ~/.config
ln -sfnv $(pwd)/nvim ~/.config/nvim && echo "ok"
nvim --headless +Lazy +qa

echo "#############################################################################"
echo "# vim-lsp"
echo "#############################################################################"

vim -c ":PlugInstall" -c "qa!"

mkdir -p ~/.local/share/vim-lsp-settings/servers
for LANG_SERVER in "pylsp-all" "clangd"; do
  cd ~/.local/share/vim-lsp-settings/servers
  if [[ -d ${LANG_SERVER} ]]; then
    echo "passed [${LANG_SERVER}]"
    continue
  fi
  mkdir -p ${LANG_SERVER}
  cd ${LANG_SERVER}
  ~/.vim/plugged/vim-lsp-settings/installer/install-${LANG_SERVER}.sh &
done
wait
