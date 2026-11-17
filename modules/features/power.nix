{ self, inputs, ... }: {

  flake.nixosModules.power = { ... }: {
    # This is a desktop reached remotely over Tailscale, so it must stay awake.
    # Left alone, GNOME's power daemon (gsd-power) requests suspend after 15
    # minutes idle on AC and both tailscaled and the SSH server become
    # unreachable from outside the LAN.
    #
    # Set as a dconf profile default, so a value changed in GNOME Settings
    # still takes priority (same pattern as the theming module). Screen
    # blanking and the lock screen are intentionally left at their defaults.
    programs.dconf.profiles.user.databases = [
      {
        settings."org/gnome/settings-daemon/plugins/power" = {
          sleep-inactive-ac-type = "nothing";
        };
      }
    ];
  };

}
