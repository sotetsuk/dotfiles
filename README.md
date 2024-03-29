[![ci](https://github.com/sotetsuk/dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/sotetsuk/dotfiles/actions/workflows/ci.yml)

# dotfiles

All dotfiles are supposed to work in both Mac and Ubuntu. 

```sh
$ ./pre-install.sh
$ ./install.sh
```

## Goals

- **Maintanable**: Keep repository small and updated.
- **Idempotent**: `./install.sh` should bring the same results after multiple runs.
- **No root permission**: No root permission is required to install.

## How to develop

To test the new feature on local machine, use the following command.

```sh
./docker_test.sh
```

## LICENSE

MIT
