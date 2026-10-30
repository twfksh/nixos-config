# nixos-config

NixOS configuration for `toufiqspc`, built with
[flake-parts](https://github.com/hercules-ci/flake-parts) and
[import-tree](https://github.com/denful/import-tree).

## Layout

- `flake.nix`: inputs and flake outputs
- `system/`: host definition and the hardware scan
- `modules/identity.nix`: username, full name, email and hostname (edit here only)
- `modules/features/`: one file per feature. A file can define the system part
  (`flake.nixosModules.<name>`), the Home Manager part (`flake.homeModules.<name>`), or both.
- `apps/`: non-Nix files used by modules: the Neovim config and the Ghostty shader
- `docs/`: reference notes for Zed and Neovim

Every `.nix` file under `modules/` and `system/` is imported automatically. To add
a feature, add a file. Home Manager modules are collected in
`modules/features/home-manager.nix`.

## First-time setup

1. Check that `system/hardware-configuration.nix` matches this machine. Regenerate
   it with `nixos-generate-config --show-hardware-config` if not.
2. Set your details in `modules/identity.nix`.
3. Stage new files. Flakes only see git-tracked files, so run `git add` on any new
   file before building.
4. Build and switch:
   ```sh
   sudo nixos-rebuild switch --flake '.#default'
   ```
5. Open a new terminal. The first start clones zap and its plugins, so it needs
   internet access.
6. Install the Rust toolchain once: `rustup default stable`.
7. Open Zed. Its extensions install on first launch.

## Usage

Quote the flake reference, since zsh treats `#` as a glob.

```sh
sudo nixos-rebuild switch --flake '.#default'   # apply
sudo nixos-rebuild test --flake '.#default'     # apply without making it the boot default
nix flake update                                # update inputs
```

## Notes

- GNOME on Wayland with Yaru theming, PipeWire, NetworkManager and CUPS.
- Shell is zsh with zap plugins and vi keys (`jk` to leave insert mode).
- Neovim is managed by Nix. Config changes need a rebuild. See `docs/neovim.md`.
- Ghostty is the default terminal. tmux uses vim-tmux-navigator.
- Git and Jujutsu share the identity from `modules/identity.nix`.
- Rootless Docker runs as a systemd user service started at login.
- Timezone is `Asia/Dhaka`.
- `system.stateVersion` and `home.stateVersion` mark the install date. Do not change them when updating.
