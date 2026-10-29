{ self, inputs, config, ... }:
let
  identity = config.identity;
in
{

  flake.homeModules.vcs = { pkgs, ... }: {
    programs.git = {
      enable = true;
      settings = {
        user = {
          name = identity.fullName;
          email = identity.email;
        };
        "credential \"https://github.com\"".helper = [
          ""
          "!${pkgs.gh}/bin/gh auth git-credential"
        ];
        "credential \"https://gist.github.com\"".helper = [
          ""
          "!${pkgs.gh}/bin/gh auth git-credential"
        ];
      };
    };

    programs.lazygit = {
      enable = true;
      settings.gui.border = "single";
    };

    programs.jujutsu = {
      enable = true;
      settings.user = {
        name = identity.fullName;
        email = identity.email;
      };
    };
  };

}
