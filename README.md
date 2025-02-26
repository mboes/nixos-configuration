# NixOS configuration files

NixOS is a Linux distribution that makes the state of your system
reproducible from one or two configuration files. This repository
captures the system state of all my devices. To reproduce the state of
any one device, checkout this repository and do the following from the
shell prompt of any NixOS installation:

```shell
$ cd /path/to/this/repo
$ sudo nixos-rebuild switch ".#$HOST"
```

You'll need to define your own `secrets.nix`, which is not checked in.

This repository is a Nix [flake][flakes].

[flakes]: https://wiki.nixos.org/wiki/Flakes
