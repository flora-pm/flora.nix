# Flora.nix


> [!NOTE]
> This canonical repo has been moved to [codeberg.org/leana8959/flora.nix](https://codeberg.org/leana8959/flora.nix),
> and will be maintained unofficially.
>
> Flora.nix is now in low maintainance mode: if you find something missing, please tell me. I will fix it when I want to.
> Patches are very welcome.

This repository contains nix expressions destined to get the tooling for Flora working.
Flora.nix tries to be as up-to-date as possible. If you find something that is outdated, please open an issue and PRs are also very welcomed.

Packaging flora in nix is a non-goal.

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
    url = "https://codeberg.org/leana8959/flora.nix/archive/c9cd342006851e179ed91072bb5b0eab7705d943.tar.gz";
  } + "/nixos-module/postgresql.nix")
];
```
