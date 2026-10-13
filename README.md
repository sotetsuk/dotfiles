[![ci](https://github.com/sotetsuk/dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/sotetsuk/dotfiles/actions/workflows/ci.yml)

# dotfiles

All dotfiles are supposed to work in both Mac and Ubuntu. 

```sh
$ ./pre-install.sh  # only on ubuntu. require sudo.
$ ./install.sh
```

## Codex CLI

On macOS, `./install.sh` installs Codex CLI with `brew install --cask codex`.
Run `codex` to start and follow the sign-in prompts.

## Local Git authentication

On a new Mac, install Homebrew and GitHub CLI, then authenticate before cloning:

```sh
brew install gh
gh auth login
git clone https://github.com/sotetsuk/dotfiles.git
cd dotfiles
./install.sh
```

During `gh auth login`, choose HTTPS and agree to authenticate Git. After
linking `.gitconfig`, the Mac installer automatically restores Git's
authentication settings in `~/.gitconfig.local`, which the shared `.gitconfig`
includes. No additional command or second login is needed. The local file is
not installed from this repository.

In GitHub Codespaces (`CODESPACES=true`), the installer leaves `~/.gitconfig`
untouched to preserve the supplied authentication. Shared Git settings are not
installed there.

## Goals

- **Maintanable**: Keep repository small and updated.
- **Idempotent**: `./install.sh` should bring the same results after multiple runs.
- **No root permission**: No root permission is required to run `./install.sh`.

## LICENSE

MIT
