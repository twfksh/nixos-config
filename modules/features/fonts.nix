{ ... }: {

  flake.nixosModules.fonts = { pkgs, ... }: {
    # UI font: Ubuntu Sans. Monospace: JetBrains Mono. Maple Mono NF is
    # available for editors/terminals, and Symbols Nerd Font Mono supplies icon
    # glyphs that JetBrains Mono lacks.
    #
    # Noto covers Bengali (Noto Sans/Serif Bengali) and the other non-CJK
    # scripts. CJK and emoji are separate packages. Unifont is the last-resort
    # fallback for anything Noto misses.
    fonts.packages = with pkgs; [
      ubuntu-sans
      jetbrains-mono
      maple-mono.NF
      nerd-fonts.symbols-only

      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      noto-fonts-monochrome-emoji
      unifont
    ];

    fonts.fontconfig = {
      defaultFonts = {
        sansSerif = [
          "Ubuntu Sans"
          "Noto Sans"
          "Noto Sans Bengali"
        ];
        serif = [
          "Noto Serif"
          "Noto Serif Bengali"
        ];
        monospace = [
          "JetBrains Mono"
          "Noto Sans Mono"
          "Noto Sans Bengali"
        ];
        emoji = [ "Noto Color Emoji" ];
      };

      # This file is applied after the generic aliases above. The appended
      # families are only used for glyphs the requested font is missing.
      localConf = ''
        <!-- Nerd Font icons for JetBrains Mono. -->
        <match target="pattern">
          <test qual="any" name="family"><string>JetBrains Mono</string></test>
          <edit name="family" mode="append" binding="strong">
            <string>Symbols Nerd Font Mono</string>
          </edit>
        </match>

        <!-- Bengali: try Noto before FreeSans/Unifont, which have Bengali
             glyphs but do not shape conjuncts and matras correctly. -->
        <match target="pattern">
          <test qual="any" name="family"><string>Ubuntu Sans</string></test>
          <edit name="family" mode="append" binding="strong">
            <string>Noto Sans Bengali</string>
          </edit>
        </match>
        <match target="pattern">
          <test qual="any" name="family"><string>JetBrains Mono</string></test>
          <edit name="family" mode="append" binding="strong">
            <string>Noto Sans Bengali</string>
          </edit>
        </match>
      '';
    };
  };

}
