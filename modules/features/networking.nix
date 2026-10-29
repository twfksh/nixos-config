{ self, inputs, config, ... }:
let
  identity = config.identity;
in
{

  flake.nixosModules.networking = { ... }: {
    networking.hostName = identity.hostname;

    # Enable networking.
    networking.networkmanager.enable = true;
  };

}
