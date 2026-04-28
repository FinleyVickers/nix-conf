# finleyv NixOS Flake

Personal NixOS and Home Manager configuration for the `nixos` host and `finleyv` user.

## Layout

- `flake.nix` defines the NixOS system, Home Manager profile, and local packages.
- `configuration.nix` is the main system module.
- `hardware-configuration.nix` is machine-specific generated hardware config.
- `home.nix` contains the user environment, Waybar, Niri, shell, and desktop config.
- `modules/` contains focused system modules.
- `pkgs/` contains local package definitions.
- `scripts/` contains deployment helpers.

## Daily Use

Build and switch the full NixOS system:

```sh
./scripts/switch
```

Build the system without activating it:

```sh
./scripts/test
```

Build as the next boot generation:

```sh
./scripts/boot
```

Apply only the standalone Home Manager profile:

```sh
./scripts/home-switch
```

Update flake inputs and build-check the result:

```sh
./scripts/update
```

## New Machine Bootstrap

On a fresh NixOS install, clone this repo and run:

```sh
./scripts/bootstrap
```

By default, this regenerates `hardware-configuration.nix`, backs up the old copy if present, and runs `nixos-rebuild boot --flake .#nixos`.

To activate immediately instead:

```sh
./scripts/bootstrap --mode switch
```

Useful environment overrides:

```sh
HOST=nixos USERNAME=finleyv ./scripts/switch
```

## Direct Commands

The scripts wrap these commands:

```sh
sudo nixos-rebuild switch --flake .#nixos
home-manager switch --flake .#finleyv
nix flake check
```

