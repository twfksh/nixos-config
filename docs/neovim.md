# Neovim

Installed and configured in `modules/features/nvim.nix` through Home Manager.
The Lua config lives in `apps/nvim/`.

## How it's wired

- `init.lua` is passed to Home Manager, which writes it to `~/.config/nvim/init.lua`.
- `lua/` and `after/` are linked into `~/.config/nvim/`.
- `~/.config/nvim/{init.lua,lua,after}` are read-only store symlinks. Anything that
  writes into the config dir (e.g. colorscheme syntax caches) must be pointed
  elsewhere or disabled — see `everforest_better_performance` in `init.lua`.
- Plugins come from nixpkgs (`programs.neovim.plugins`). There is no plugin manager.
- Language servers and tools are on `PATH` through `programs.neovim.extraPackages`.
  Mason is not used.
- Changes need a rebuild: `sudo nixos-rebuild switch --flake '.#default'`.

`init.lua` starts with `vim.cmd("packloadall")`. Plugins are loaded after `init.lua`
by default, but this config requires them at the top of the file, so keep that line.

## LSP keys

`lua/lsp/mappings.lua` adds buffer-local `gd` (go to definition) and `gD` (go to
declaration), mapped only when an attached server supports the request so they
do not shadow Vim's tags lookup elsewhere. `]d` and `[d` jump between
diagnostics.

The rest are Neovim 0.12 defaults: `grn` rename, `gra` code action, `grr`
references, `gri` implementation, `grt` type definition, `gO` document symbols,
`K` hover. The config also has fzf-lua pickers on `<leader>fr` (references),
`<leader>fd` (document diagnostics), `<leader>ca` (code actions) and
`<leader>ft` (type definitions).

fzf-lua is registered as the `vim.ui.select` implementation, so any chooser the
editor opens itself — a jump with several locations, `vim.lsp.buf.code_action`
— uses the same picker and window style as the rest.

## Adding things

- **Plugin:** add `pkgs.vimPlugins.<name>` to `programs.neovim.plugins`, then configure
  it in `init.lua`.
- **Language server:** add its nixpkgs package to `extraPackages`, then enable it with
  `vim.lsp.enable({ ... })` in `init.lua`. Names must match the server's `nvim-lspconfig` name.
- Check package and plugin names with `nix search nixpkgs <name>` before adding them.
