{ self, inputs, ... }: {

  flake.homeModules.zed = { pkgs, ... }:
    let
      # Zed feeds the buffer on stdin and reads the formatted text from stdout, so
      # every external formatter below is invoked in stdin->stdout mode.
      clangFormat = {
        external = {
          command = "${pkgs.clang-tools}/bin/clang-format";
          arguments = [ "--assume-filename" "{buffer_path}" ];
        };
      };

      prettier = {
        external = {
          command = "${pkgs.prettier}/bin/prettier";
          arguments = [ "--stdin-filepath" "{buffer_path}" ];
        };
      };
    in
    {
      # Installed from nixpkgs rather than zed.dev's install.sh: the script's
      # prebuilt binary expects FHS library paths and cannot find glib/gio/alsa
      # on NixOS, so it exits immediately.
      programs.zed-editor = {
        enable = true;

        # C/C++, Rust and TypeScript/JavaScript support is built into Zed; the
        # rest come from the extension registry and are installed on startup.
        extensions = [
          "zig"
          "csharp"
          "lua"
          "nix"
          "macos-classic"
        ];

        userSettings = {
          theme = "macOS Classic Dark";
          buffer_font_family = "JetBrains Mono";
          terminal.font_family = "JetBrains Mono";

          # Format only the languages explicitly configured below.
          format_on_save = "off";

          # Zed's js-debug and vtsls need a Node runtime; use the system LTS
          # instead of letting Zed download its own copy.
          node = {
            path = "${pkgs.nodejs_26}/bin/node";
            npm_path = "${pkgs.nodejs_26}/bin/npm";
          };

          lsp = {
            clangd.binary.path = "${pkgs.clang-tools}/bin/clangd";
            zls.binary.path = "${pkgs.zls}/bin/zls";
            rust-analyzer.binary.path = "${pkgs.rust-analyzer}/bin/rust-analyzer";

            # Roslyn is the official C# server. Pointing at it directly avoids the
            # extension's NuGet download; Zed does not add these flags itself when
            # a custom binary path is set.
            roslyn.binary = {
              path = "${pkgs.roslyn-ls}/bin/Microsoft.CodeAnalysis.LanguageServer";
              arguments = [
                "--stdio"
                "--autoLoadProjects"
              ];
            };

            vtsls.binary = {
              path = "${pkgs.vtsls}/bin/vtsls";
              arguments = [ "--stdio" ];
            };

            "lua-language-server".binary.path = "${pkgs.lua-language-server}/bin/lua-language-server";
            nixd.binary.path = "${pkgs.nixd}/bin/nixd";
            gopls.binary.path = "${pkgs.gopls}/bin/gopls";

            pyrefly.binary = {
              path = "${pkgs.pyrefly}/bin/pyrefly";
              arguments = [ "lsp" ];
            };
            ruff.binary = {
              path = "${pkgs.ruff}/bin/ruff";
              arguments = [ "server" ];
            };

            "tailwindcss-language-server".binary = {
              path = "${pkgs.tailwindcss-language-server}/bin/tailwindcss-language-server";
              arguments = [ "--stdio" ];
            };
          };

          # Debug adapters. CodeLLDB is downloaded by Zed on first use and runs
          # unpatched on NixOS; GDB comes from nixpkgs.
          dap.GDB.binary = "${pkgs.gdb}/bin/gdb";

          languages = {
            "Go" = {
              format_on_save = "on";
            };
            "Python" = {
              format_on_save = "on";
              # Pyrefly replaces the default basedpyright; ruff stays for lint and format.
              language_servers = [ "pyrefly" "!basedpyright" "..." ];
              formatter = { language_server = { name = "ruff"; }; };
            };
            "C" = {
              format_on_save = "on";
              formatter = clangFormat;
            };
            "C++" = {
              format_on_save = "on";
              formatter = clangFormat;
            };
            "Zig" = {
              format_on_save = "on";
              formatter = { language_server = { name = "zls"; }; };
            };
            "Rust" = {
              format_on_save = "on";
              formatter = { language_server = { name = "rust-analyzer"; }; };
            };
            # C# has no debug adapter in the released extension; debugging is
            # blocked on zed-extensions/csharp#95 (netcoredbg).
            "CSharp" = {
              format_on_save = "on";
              formatter = { language_server = { name = "roslyn"; }; };
            };
            "JavaScript" = {
              format_on_save = "on";
              formatter = prettier;
            };
            "TypeScript" = {
              format_on_save = "on";
              formatter = prettier;
            };
            "TSX" = {
              format_on_save = "on";
              formatter = prettier;
            };
            "Lua" = {
              format_on_save = "on";
              formatter = {
                external = {
                  command = "${pkgs.stylua}/bin/stylua";
                  # stylua only reads stdin when "-" is passed as the file.
                  arguments = [ "--stdin-filepath" "{buffer_path}" "-" ];
                };
              };
            };
            "Nix" = {
              format_on_save = "on";
              formatter = {
                external = {
                  command = "${pkgs.nixfmt}/bin/nixfmt";
                  # nixfmt wants an explicit "-" to read from stdin.
                  arguments = [ "-" ];
                };
              };
              # The nix extension registers both nil and nixd; keep only nixd.
              language_servers = [ "nixd" "!nil" "..." ];
            };
          };
        };
      };
    };

}
