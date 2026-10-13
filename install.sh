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
# * ripgrep is required by kickstart.nvim
brew install tmux gh bat xsel tree pygments wget aichat neovim ripgrep node zoxide diff-so-fancy jq fzf herdr 2>/dev/null

# install Codex CLI using the Homebrew cask on macOS
if [[ $(uname -s) == Darwin ]]; then
  brew install --cask codex
fi

# clean up old git-based fzf installation (now managed by brew)
if [[ -e ~/.fzf ]]; then
  rm -rf ~/.fzf ~/.fzf.zsh ~/.fzf.bash
  [[ -e ~/.zshrc ]] && sed -i.bak '/\.fzf\.zsh/d' ~/.zshrc && rm -f ~/.zshrc.bak
  [[ -e ~/.bashrc ]] && sed -i.bak '/\.fzf\.bash/d' ~/.bashrc && rm -f ~/.bashrc.bak
  echo "removed old git-based fzf (replaced by brew fzf)"
fi

echo "#############################################################################"
echo "# Set dotfiles"
echo "#############################################################################"

dotfiles="
.vimrc
.ideavimrc
.tmux.conf
.zshrc.common
.npmrc
.bunfig.toml
.config/uv/uv.toml
.local/bin/tmx
.local/bin/tmux-git-curr-branch
.local/bin/tmux-git-status
.local/bin/p
.local/bin/i
.local/bin/jiggle
.local/bin/screen-sharing
.local/bin/compress_videos
.local/bin/m2h
.local/bin/gsync
.local/bin/cw
.local/libexec/claude-worktree-history.sh
.local/libexec/claude-worktree-include.sh
"

mkdir -p ~/.local/bin ~/.local/libexec ~/.config/uv
for dotfile in ${dotfiles}; do
    ln -sfnv $(pwd)/${dotfile} ~/${dotfile}
done

# Preserve the Git configuration supplied by Codespaces.
if [[ ${CODESPACES:-} != true ]]; then
    ln -sfnv "$(pwd)/.gitconfig" "$HOME/.gitconfig"
    if [[ $(uname -s) == Darwin ]]; then
        GIT_CONFIG_GLOBAL="$HOME/.gitconfig.local" gh auth setup-git
    fi
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
echo "# vim-lsp"
echo "#############################################################################"

vim -c ":PlugInstall" -c "qa!"
