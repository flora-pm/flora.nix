# Flora.nix

This repository contains a nix expressions destined to get the tooling for Flora working.
Flora.nix tries to be as up-to-date as possible. If you find something that is outdated, please open an issue and PRs are also very welcomed.

Packaging flora in nix is a non-goal at the moment.

## Usage
```bash
nix-shell ./path/to/flora.nix --arg withHLS true
```

See shell.nix for the complete list of argument.

Quick and dirty way to use the NixOS module:
```nix
imports = [
  # Replace the commit with a pin you want.
  (builtins.fetchTarball {
    url = "https://github.com/flora-pm/flora.nix/archive/993e0ddb96a06d6cd8f99324cdc75f931ce36d02.tar.gz";
  } + "/nixos-module/postgresql.nix")
];
```
