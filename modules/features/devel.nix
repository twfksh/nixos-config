{ self, inputs, ... }: {

  flake.nixosModules.devel = { pkgs, ... }: {
    # Installed system-wide so every editor and shell finds them on PATH.
    environment.systemPackages = with pkgs; [
      # Languages and runtimes
      go
      rustup
      dotnet-sdk_10
      nodejs_26
      bun
      zig

      # Build tools and debugger
      gcc
      gnumake
      binutils
      pkg-config
      cmake
      autoconf
      automake
      libtool
      tree-sitter
      gdb
      # CodeLLDB debug adapter, from the VS Code extension's prebuilt binary.
      (writeShellScriptBin "codelldb" ''
        exec ${vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb "$@"
      '')

      # Language servers
      nixd
      gopls
      roslyn-ls
      lua-language-server
      rust-analyzer
      clang-tools
      zls
      tinymist
      ruff
      pyrefly
      vtsls
      svelte-language-server
      tailwindcss-language-server
      vscode-langservers-extracted
      glsl_analyzer

      # Formatters and linters
      nixfmt
      stylua
    ];
  };

}
