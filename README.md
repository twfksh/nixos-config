# nixos-config

NixOS configuration for `toufiqspc`, built with
[flake-parts](https://github.com/hercules-ci/flake-parts) and auto-imported
with [import-tree](https://github.com/denful/import-tree).

## Layout

- `flake.nix` — inputs and flake outputs
- `system/` — host definition, `configuration.nix`, and the hardware scan
- `modules/features/` — one NixOS module per feature (`base`, `networking`,
  `desktop`, `theming`, `audio`, `printing`, `users`, `shell`)

Every `.nix` file under `modules/` and `system/` is imported automatically, so
adding a feature just means adding a file.

## Usage

```sh
sudo nixos-rebuild switch --flake .#toufiqspc
```

Build without activating:

```sh
sudo nixos-rebuild test --flake .#toufiqspc
```

Update inputs:

```sh
nix flake update
```

## Notes

- GNOME (Wayland) with Yaru theming, PipeWire, NetworkManager, CUPS, zsh.
- Default user `toufiq`; timezone `Asia/Dhaka`.
- `system.stateVersion` tracks the install, not nixpkgs — leave it alone.
