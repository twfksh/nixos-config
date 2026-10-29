{ self, inputs, ... }: {

  flake.nixosModules.theming = { pkgs, lib, ... }: {
    # Yaru (Ubuntu's theme) for GTK, icons, cursors, sounds and the GNOME Shell.
    environment.systemPackages = with pkgs; [
      # yaru-theme ships a "Yaru session" .desktop file, which GDM would list
      # next to GNOME. Strip it so GDM only offers GNOME.
      (yaru-theme.overrideAttrs (old: {
        postInstall = (old.postInstall or "") + ''
          rm -rf "$out/share/wayland-sessions"
        '';
      }))
      gnomeExtensions.user-themes
      gnomeExtensions.rounded-window-corners-reborn
    ];

    # UI font: Ubuntu Sans. Monospace: JetBrains Mono. Maple Mono NF is
    # available for editors/terminals, and Symbols Nerd Font Mono supplies icon
    # glyphs that JetBrains Mono lacks.
    fonts.packages = with pkgs; [
      ubuntu-sans
      jetbrains-mono
      maple-mono.NF
      nerd-fonts.symbols-only
    ];

    # Fontconfig fallback only kicks in for glyphs JetBrains Mono is missing
    # (Nerd Font icons); Maple Mono NF already bundles them.
    fonts.fontconfig.localConf = ''
      <match target="pattern">
        <test qual="any" name="family"><string>JetBrains Mono</string></test>
        <edit name="family" mode="append" binding="strong">
          <string>Symbols Nerd Font Mono</string>
        </edit>
      </match>
    '';

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
            monospace-font-name = "JetBrains Mono 13";
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
