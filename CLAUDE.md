# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a dotfiles repository designed to work on both macOS and Ubuntu systems. It provides a unified development environment configuration with automatic installation scripts.

## Key Commands

### Installation
```bash
# On Ubuntu only - installs system dependencies (requires sudo)
./pre-install.sh

# Main installation script - idempotent and requires no root permissions
./install.sh
```

### Testing
```bash
# Run tests to verify all tools are installed correctly
./tests.sh
```

## Architecture

The repository follows a modular approach:

1. **Installation Scripts**:
   - `pre-install.sh`: Ubuntu-specific system package installation (git, curl, zsh, build-essential)
   - `install.sh`: Main installation script that:
     - Installs oh-my-zsh
     - Installs Homebrew (if not present)
     - Installs development tools via brew (tmux, gh, bat, neovim, ripgrep, etc.)
     - Symlinks dotfiles to home directory
     - Sets up fzf, iterm2 utilities, uv, and language servers

2. **Dotfiles Structure**:
   - Configuration files are kept in the repository root (`.vimrc`, `.gitconfig`, `.tmux.conf`, etc.)
   - Custom scripts are in `.local/bin/` directory
   - Neovim configuration is maintained as a git submodule in `nvim/`

3. **Key Principles**:
   - **Idempotent**: Running `install.sh` multiple times produces the same result
   - **No root required**: Only `pre-install.sh` requires sudo on Ubuntu
   - **Cross-platform**: Works on both macOS and Ubuntu

## Development Workflow

When modifying dotfiles:
1. Edit the source files in this repository
2. Run `./install.sh` to update symlinks
3. Run `./tests.sh` to verify installation
4. Test changes in a new shell session

