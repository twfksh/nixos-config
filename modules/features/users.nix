{ self, inputs, config, ... }:
let
  identity = config.identity;
in
{

  flake.nixosModules.users = { pkgs, ... }: {
    users.users.${identity.username} = {
      isNormalUser = true;
      # Pinned so the rootless Docker socket path can be derived declaratively.
      uid = 1000;
      description = identity.fullName;
      extraGroups = [ "networkmanager" "wheel" "uinput" ];
      shell = pkgs.zsh;
    };
  };

}
