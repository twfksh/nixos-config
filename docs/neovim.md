# Neovim

Installed and configured in `modules/features/nvim.nix` through Home Manager.
The Lua config lives in `assets/nvim/`.

## How it's wired

- `init.lua` is passed to Home Manager, which writes it to `~/.config/nvim/init.lua`.
- `lua/` and `after/` are linked into `~/.config/nvim/`.
- Plugins come from nixpkgs (`programs.neovim.plugins`). There is no plugin manager.
- Language servers and tools are on `PATH` through `programs.neovim.extraPackages`.
  Mason is not used.
- Changes need a rebuild: `sudo nixos-rebuild switch --flake '.#default'`.

`init.lua` starts with `vim.cmd("packloadall")`. Plugins are loaded after `init.lua`
by default, but this config requires them at the top of the file, so keep that line.

## Adding things

- **Plugin:** add `pkgs.vimPlugins.<name>` to `programs.neovim.plugins`, then configure
  it in `init.lua`.
- **Language server:** add its nixpkgs package to `extraPackages`, then enable it with
  `vim.lsp.enable({ ... })` in `init.lua`. Names must match the server's `nvim-lspconfig` name.
- Check package and plugin names with `nix search nixpkgs <name>` before adding them.
