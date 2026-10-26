{ self, inputs, ... }: {

  flake.nixosConfigurations.toufiqspc = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.systemConfiguration
    ];
  };

}
