{ self, inputs, ... }: {

  flake.nixosModules.desktop = { pkgs, ... }: {
    # Enable the GNOME Desktop Environment.
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    # Configure keymap in X11.
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };

    # Enable touchpad support.
    services.libinput.enable = true;

    # Enable OpenTabletDriver for drawing tablets. This installs the package,
    # its udev rules, and runs the daemon as a user service. It also blacklists
    # the conflicting `wacom` and `hid-uclogic` kernel modules.
    hardware.opentabletdriver.enable = true;

    # OTD needs the uinput kernel module to create its virtual pen/mouse device.
    hardware.uinput.enable = true;

    # Trim a few unused GNOME default apps.
    environment.gnome.excludePackages = with pkgs; [
      # Docs and onboarding
      gnome-user-docs
      yelp
      gnome-tour
      # Redundant with Firefox
      epiphany
      # Replaced by Resources below
      gnome-system-monitor
      # Unused
      gnome-maps
      gnome-connections
    ];

    # Process/resource monitor to replace GNOME System Monitor.
    environment.systemPackages = with pkgs; [ resources ];

    # Install Firefox with browser integration.
    programs.firefox.enable = true;
  };

}
