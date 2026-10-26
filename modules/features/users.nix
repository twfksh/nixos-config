{ self, inputs, ... }: {

  flake.nixosModules.users = { pkgs, ... }: {
    users.users.toufiq = {
      isNormalUser = true;
      description = "Toufiq Shishir";
      extraGroups = [ "networkmanager" "wheel" "uinput" ];
      shell = pkgs.zsh;
    };
  };

}
