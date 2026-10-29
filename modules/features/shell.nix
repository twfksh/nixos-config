{ self, inputs, ... }: {

  flake.nixosModules.shell = { pkgs, ... }: {
    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;
  };

  flake.homeModules.shell = {
    programs.zsh = {
      enable = true;

      initContent = ''
        # Install zap on first shell start. Nix does not package it, so it is
        # cloned from GitHub into the XDG data directory.
        ZAP_DIR="''${XDG_DATA_HOME:-$HOME/.local/share}/zap"
        if [[ ! -f "$ZAP_DIR/zap.zsh" ]]; then
          git clone --depth 1 --branch release-v1 https://github.com/zap-zsh/zap.git "$ZAP_DIR"
        fi
        source "$ZAP_DIR/zap.zsh"

        plug "zap-zsh/supercharge"
        plug "zsh-users/zsh-autosuggestions"
        plug "zsh-users/zsh-syntax-highlighting" "122dc46"
        plug "zap-zsh/zap-prompt"
        plug "esc/conda-zsh-completion"

        export VI_MODE_ESC_INSERT="jk"
        plug "zap-zsh/vim"
      '';
    };

    home.sessionPath = [
      "$HOME/.opencode/bin"
      "$HOME/.pi/agent/bin"
      "$HOME/.local/bin"
      "$HOME/.bun/bin"
      "$HOME/.cargo/bin"
      "$HOME/.dotnet/tools"
      "$HOME/go/bin"
    ];
  };

}
