# NixOS configuration files

[NixOS][nixos] is a Linux distribution that makes the state of your system
reproducible from one or two configuration files. This repository
captures the system state of all my devices. To reproduce the state of
any one device, checkout this repository and do the following from the
shell prompt of any existing NixOS instance:

```shell
$ cd /path/to/this/repo
$ nixos-rebuild build ".#$HOST"
$ sudo nixos-rebuild switch ".#$HOST"
```

Some settings are stored separately in a private repository. If you
don't have access, remove the corresponding input in `flake.nix`.

This repository is a Nix [flake][flakes].

[flakes]: https://wiki.nixos.org/wiki/Flakes
[nixos]: https://nixos.org/
