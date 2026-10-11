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

## macOS Screen Sharing

```sh
screen-sharing on      # enable now and after reboot (prompts for sudo)
screen-sharing off     # disable and disconnect current sessions (prompts for sudo)
screen-sharing status  # show on/off without sudo; also the default with no arguments
```

`on` / `off` control the `com.apple.screensharing` launchd service. `status`
reports whether it is loaded, including when it is waiting for a connection;
it does not test remote connectivity or report active viewers.
Manage allowed users in System Settings > General > Sharing > Screen Sharing.
If Remote Management is enabled, turn it off there before using Screen Sharing
([Apple's setup guide](https://support.apple.com/guide/mac-help/mh11848/mac)).

## LICENSE

MIT
