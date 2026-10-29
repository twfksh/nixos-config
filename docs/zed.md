# Zed

Configured in `modules/features/zed.nix` through Home Manager. Installed from
nixpkgs, not `zed.dev/install.sh`, whose binary can't find glib/gio/alsa on NixOS.
The CLI is `zeditor`.

## Languages

| Language | LSP | Format on save | Debugger |
|---|---|---|---|
| C / C++ | clangd | clang-format | GDB, CodeLLDB |
| Zig | zls (ext `zig`) | zls | CodeLLDB/GDB (manual) |
| Rust | rust-analyzer | rust-analyzer | CodeLLDB (F4) |
| C#/.NET | Roslyn (ext `csharp`) | Roslyn | none |
| TS / JS | vtsls | prettier | vscode-js-debug (F4) |
| Lua | lua-language-server (ext `lua`) | stylua | none |
| Nix | nixd (ext `nix`) | nixfmt | n/a |
| Go | gopls | gopls | Delve (F4) |
| Python | pyrefly + ruff | ruff | debugpy (F4) |

Built in: C/C++, Rust, TypeScript and JavaScript. Auto-installed extensions: `zig`,
`csharp`, `lua`, `nix`.

## Binaries

- Language servers are pinned by path in `lsp.*.binary.path`.
- Compilers, language servers, formatters and GDB come from
  `modules/features/devel.nix` on the system PATH. Zed doesn't need its own copies.
- Node is `nodejs_26`, set in `node.path` and `node.npm_path`.
- Roslyn needs `--stdio --autoLoadProjects`, since Zed adds no flags to a custom path.
- CodeLLDB downloads on first debug (~50 MB) and runs unpatched on NixOS.

## Debugging

Rust and JS/TS debug with F4 and need no setup. C/C++ and Zig need a project
`.zed/debug.json`:

```json
[
  {
    "label": "Debug",
    "adapter": "GDB",
    "request": "launch",
    "program": "$ZED_WORKTREE_ROOT/build/app",
    "cwd": "$ZED_WORKTREE_ROOT"
  }
]
```

Use `"adapter": "CodeLLDB"` for LLDB. Build with debug info (`-g`,
`cargo build`, or `zig build -Doptimize=Debug`).

C# has no debugger yet: the `csharp` extension lacks an adapter
(`zed-extensions/csharp#95`).

## Notes

- Formatters read stdin and write stdout. `stylua` and `nixfmt` need a trailing `-`.
- Format on save is set per language, not globally.
- Zed updates with `nix flake update`, not on its own.
