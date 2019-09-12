Personal NixOS config

- `functionality/` contains application programs.
- `hardware/` contains settings for specific hardware (like mbpfan).
- `instance/` contains device specific settings that is distinct with every installation (like partitions).

Symlink files from `instance/` to `/etc/nixos/configuration.nix` to use the configuration.
