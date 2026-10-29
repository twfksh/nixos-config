{ self, inputs, config, ... }:
let
  identity = config.identity;
in
{

  flake.nixosModules.homeManager = { ... }: {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    home-manager = {
      # Build user packages with the system nixpkgs and install them through
      # users.users.<username>.packages instead of a separate nixpkgs instance.
      useGlobalPkgs = true;
      useUserPackages = true;

      # Move pre-existing files aside instead of failing activation.
      backupFileExtension = "hm-backup";

      users.${identity.username} = {
        imports = [
          self.homeModules.shell
          self.homeModules.terminal
          self.homeModules.tmux
          self.homeModules.zed
          self.homeModules.vcs
          self.homeModules.nvim
        ];

        # Matches the system install date. Home Manager state versions are
        # independent of nixpkgs and should not be bumped on upgrades.
        home.stateVersion = "26.05";
      };
    };
  };

}
