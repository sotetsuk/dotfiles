# dotfiles

All dotfiles are supposed to work in both Mac and Linux. 

**Mac**

```sh
$ cut -f 1 required.tsv | xargs brew install
$ ./install.sh
$ zsh ./tests.sh
```

**Ubuntu**

```sh
$ sudo apt update && sudo apt install -y git
$ cut -f 2 required.tsv | xargs sudo apt install -y
$ ./install.sh
$ zsh ./tests.sh
```


## LICENSE

MIT
