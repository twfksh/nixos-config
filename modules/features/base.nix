{ self, inputs, ... }: {

  flake.nixosModules.base = { pkgs, ... }: {
    # Enable flakes.
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # Allow unfree packages.
    nixpkgs.config.allowUnfree = true;

    # Dedupe identical files in the store via hardlinks.
    nix.settings.auto-optimise-store = true;

    # Weekly garbage collection: drop system/root profile generations older
    # than two weeks along with the store paths they alone reference.
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

    # Run unpatched dynamic binaries.
    programs.nix-ld.enable = true;

    time.timeZone = "Asia/Dhaka";
    i18n.defaultLocale = "en_US.UTF-8";

    environment.systemPackages = with pkgs; [
      htop
      wget
      curl
      ripgrep
      fzf
      git
      fd
      gh
      chafa
    ];
  };

}
