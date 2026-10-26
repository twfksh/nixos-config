{ self, inputs, ... }: {

  flake.nixosModules.networking = { ... }: {
    networking.hostName = "toufiqspc";

    # Enable networking.
    networking.networkmanager.enable = true;
  };

}
