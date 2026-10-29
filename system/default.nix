{ self, inputs, ... }: {

  flake.nixosConfigurations.default = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.systemConfiguration
    ];
  };

}
