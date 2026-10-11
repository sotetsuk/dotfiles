[![ci](https://github.com/sotetsuk/dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/sotetsuk/dotfiles/actions/workflows/ci.yml)

# dotfiles

All dotfiles are supposed to work in both Mac and Ubuntu. 

```sh
$ ./pre-install.sh  # only on ubuntu. require sudo.
$ ./install.sh
```

## Goals

- **Maintanable**: Keep repository small and updated.
- **Idempotent**: `./install.sh` should bring the same results after multiple runs.
- **No root permission**: No root permission is required to run `./install.sh`.

## LICENSE

MIT
