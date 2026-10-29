{ self, inputs, ... }: {

  flake.nixosModules.terminal = { pkgs, lib, ... }: {
    environment.systemPackages = with pkgs; [
      ghostty
      # Ghostty uses TERM=xterm-ghostty; its terminfo entry lives in a
      # separate output so curses apps (vim, less, ...) work.
      ghostty.terminfo
    ];

    # GNOME's default-terminal setting routes through xdg-terminal-exec, as
    # used by Alt+F2 "run in terminal", Nautilus and other desktop apps.
    xdg.terminal-exec = {
      enable = true;
      settings.default = [ "com.mitchellh.ghostty.desktop" ];
    };

    # Drop GNOME Console, the previous default terminal.
    environment.gnome.excludePackages = with pkgs; [ gnome-console ];

    # GNOME no longer ships a terminal shortcut, so bind Ctrl+Alt+T.
    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/settings-daemon/plugins/media-keys" = {
            custom-keybindings = [
              "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal/"
            ];
          };
          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal" = {
            name = "Terminal";
            command = "${lib.getExe pkgs.ghostty}";
            binding = "<Control><Alt>t";
          };
        };
      }
    ];
  };

  # Ported from ~/dotfiles/ghostty/.config/ghostty/config.
  flake.homeModules.terminal = {
    programs.ghostty.enable = true;
    programs.ghostty.settings = {
      # Window
      gtk-single-instance = true;
      gtk-titlebar-style = "tabs";
      window-subtitle = "working-directory";
      window-padding-balance = true;
      window-width = 100;
      window-height = 28;

      # Only the cursor smear shader is used; the other shaders in the
      # dotfiles are intentionally not ported.
      custom-shader = "./shaders/cursor_smear.glsl";

      # Fonts. The dotfiles use "JetBrainsMono Nerd Font" and "Maple NF",
      # which are not installed here; JetBrains Mono (with Symbols Nerd Font
      # Mono as the fallback) and Maple Mono NF are the installed equivalents.
      font-family = [
        "JetBrains Mono"
        "Symbols Nerd Font Mono"
      ];
      font-family-bold = "JetBrains Mono";
      font-family-italic = "Maple Mono NF";
      font-family-bold-italic = "Maple Mono NF";
      font-size = 13;
      adjust-underline-position = 4;

      # Mouse
      mouse-hide-while-typing = true;

      # Cursor and colors
      cursor-invert-fg-bg = true;
      background-opacity = "0.9";
      window-theme = "ghostty";
      theme = "Everforest Dark Hard";

      # Keybindings
      keybind = [
        "clear"
        "alt+t=new_tab"
        "alt+shift+enter=new_split:auto"

        "alt+h=previous_tab"
        "alt+l=next_tab"

        "alt+shift+h=goto_split:left"
        "alt+shift+j=goto_split:bottom"
        "alt+shift+k=goto_split:top"
        "alt+shift+l=goto_split:right"

        "alt+shift+comma=move_tab:-1"
        "alt+shift+period=move_tab:1"

        "ctrl+shift+c=copy_to_clipboard"
        "ctrl+shift+v=paste_from_clipboard"

        "super+shift+i=inspector:toggle"
        "super+shift+r=reload_config"
        "super+shift+s=write_screen_file:open"
        "alt+shift+w=close_surface"

        "ctrl+shift+p=toggle_command_palette"
      ];

      # Other
      copy-on-select = true;
      selection-clear-on-copy = true;
      shell-integration-features = "cursor,sudo,no-title";
    };

    # Ghostty resolves custom-shader paths relative to its config file, so the
    # shader must live next to ~/.config/ghostty/config.
    xdg.configFile."ghostty/shaders/cursor_smear.glsl".source =
      ../../assets/ghostty/shaders/cursor_smear.glsl;
  };

}
