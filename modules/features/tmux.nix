{ self, inputs, ... }: {

  # Ported from ~/dotfiles/tmux/.tmux.conf. TPM is replaced by Home Manager's
  # plugin support, and the grey theme is dropped in favour of the terminal's
  # own surface colours.
  flake.homeModules.tmux = { pkgs, ... }: {
    programs.tmux = {
      enable = true;
      mouse = true;
      baseIndex = 1;
      prefix = "C-Space";
      sensibleOnTop = true;

      # tmux 3.8 defaults to tmux-256color; Home Manager would otherwise select
      # "screen".
      terminal = "tmux-256color";

      plugins = [ pkgs.tmuxPlugins.vim-tmux-navigator ];

      extraConfig = ''
        # Terminal capabilities: keep the dotfiles' xterm-256color override and
        # enable truecolor for Ghostty's terminfo, which does not advertise Tc.
        set-option -ga terminal-overrides ",xterm-256color:Tc"
        set-option -ga terminal-overrides ",xterm-ghostty:Tc"

        setw -g renumber-windows on

        # Inherit Ghostty's Everforest surface instead of the removed grey theme.
        set -g theme terminal
        set -g status-style default
        set -g pane-border-style default
        set -g pane-active-border-style default
        set -g message-style default
        set -g message-command-style default
        set -g mode-style default

        # Status-line layout from the dotfiles, with the hardcoded colours
        # stripped out.
        set -g status-left-length 50
        set -g status-right-length 100
        set -g status-justify left
        set -g status-left " #{session_name} "
        set -g status-right " #(uptime | cut -d',' -f3- | sed 's/load average://') │ %H:%M │ %d %b #h "
        set -g window-status-format " #I:#W#F "
        set -g window-status-current-format " #I:#W#F "
        set -g window-status-separator ""
      '';
    };
  };

}
