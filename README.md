# NixOS configuration files

NixOS is a Linux distribution that makes the state of your system
reproducible from one or two configuration files. This repository
captures the system state of all my devices. To reproduce, do the
following from the shell prompt of any NixOS installation:

```shell
$ cd /etc/nixos
$ sudo ln -s /path/to/this/repo/configuration.nix
$ sudo ln -s /path/to/this/repo/devices/.../hardware-configuration.nix
$ sudo nixos-rebuild switch
```
