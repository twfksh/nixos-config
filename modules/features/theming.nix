{ self, inputs, ... }: {

  flake.nixosModules.theming = { pkgs, lib, ... }: {
    # Yaru (Ubuntu's theme) for GTK, icons, cursors, sounds and the GNOME Shell.
    environment.systemPackages = with pkgs; [
      yaru-theme
      gnomeExtensions.user-themes
      gnomeExtensions.rounded-window-corners-reborn
      ubuntu-sans
      ubuntu-sans-mono
    ];

    # Cursor for XWayland and other non-GNOME clients.
    environment.sessionVariables = {
      XCURSOR_THEME = "Yaru";
      XCURSOR_SIZE = "24";
    };

    # System-wide defaults. These live in the dconf file-db, so values set by
    # the user in GNOME Settings/Tweaks still take priority.
    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/desktop/interface" = {
            gtk-theme = "Yaru-dark";
            icon-theme = "Yaru-dark";
            cursor-theme = "Yaru";
            cursor-size = lib.gvariant.mkInt32 24;
            color-scheme = "prefer-dark";
            accent-color = "orange";
            font-name = "Ubuntu Sans 11";
            document-font-name = "Ubuntu Sans 11";
            monospace-font-name = "Ubuntu Sans Mono 13";
          };

          "org/gnome/desktop/sound" = {
            theme-name = "Yaru";
            input-feedback-sounds = true;
          };

          "org/gnome/desktop/wm/preferences" = {
            button-layout = ":minimize,maximize,close";
            titlebar-font = "Ubuntu Sans Bold 11";
            # Fixed workspace count; only honoured while dynamic-workspaces
            # (org/gnome/mutter) is disabled.
            num-workspaces = lib.gvariant.mkInt32 4;
          };

          "org/gnome/mutter" = {
            dynamic-workspaces = false;
          };

          # GNOME Shell (top bar, overview, lock screen) theming needs the
          # User Themes extension, since Shell has no built-in theme setting.
          "org/gnome/shell" = {
            enabled-extensions = [
              "user-theme@gnome-shell-extensions.gcampax.github.com"
              "rounded-window-corners@fxgn"
            ];
          };

          "org/gnome/shell/extensions/user-theme" = {
            name = "Yaru-dark";
          };
        };
      }
    ];
  };

}
