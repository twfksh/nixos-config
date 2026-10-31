{ self, inputs, ... }:

let
  # User-level tool directories. Shared by the Home Manager session path and
  # the zsh fallback below so the two lists cannot drift apart.
  userBinDirs = [
    "$HOME/.opencode/bin"
    "$HOME/.pi/agent/bin"
    "$HOME/.local/bin"
    "$HOME/.bun/bin"
    "$HOME/.cargo/bin"
    "$HOME/.dotnet/tools"
    "$HOME/go/bin"
  ];
in {

  flake.nixosModules.shell = { pkgs, ... }: {
    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;
  };

  flake.homeModules.shell = { lib, ... }: {
    home.sessionPath = userBinDirs;

    programs.zsh = {
      enable = true;

      initContent = ''
        # Home Manager applies home.sessionPath from hm-session-vars.sh, which is
        # sourced once per login session and returns early whenever
        # __HM_SESS_VARS_SOURCED is already exported. GDM hands the graphical
        # session a stale copy of that variable with a PATH that lacks these
        # directories, so add them here as well. typeset -U path (set above by
        # Home Manager) drops duplicates and keeps the first occurrence.
        path=(${lib.concatMapStringsSep " " (dir: "\"${dir}\"") userBinDirs} $path)

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
  };

}
