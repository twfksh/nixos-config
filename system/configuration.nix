{ self, inputs, ... }: {

  flake.nixosModules.systemConfiguration = { pkgs, lib, ... }: {
    imports = [
      self.nixosModules.systemHardware
      self.nixosModules.base
      self.nixosModules.devel
      self.nixosModules.networking
      self.nixosModules.docker
      self.nixosModules.desktop
      self.nixosModules.terminal
      self.nixosModules.homeManager
      self.nixosModules.theming
      self.nixosModules.audio
      self.nixosModules.printing
      self.nixosModules.users
      self.nixosModules.shell
    ];

    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Keep the boot menu short so the EFI partition doesn't fill up with old
    # kernels and initrds. The store paths themselves are cleaned by nix.gc.
    boot.loader.systemd-boot.configurationLimit = 10;

    # Use latest kernel.
    boot.kernelPackages = pkgs.linuxPackages_latest;

    # Compressed RAM swap. Prefer zram over the disk swap partition, which
    # stays available as a fallback for high memory pressure.
    zramSwap = {
      enable = true;
      memoryPercent = 50;
      priority = 100;
    };

    # Initial NixOS version this machine was installed with. Do not bump
    # this to track nixpkgs upgrades.
    system.stateVersion = "26.05";
  };

}
