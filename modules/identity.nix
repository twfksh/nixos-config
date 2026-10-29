{ lib, ... }: {

  options.identity = lib.mkOption {
    type = lib.types.submodule {
      options = {
        username = lib.mkOption {
          type = lib.types.str;
          description = "Login name of the primary user.";
        };
        fullName = lib.mkOption {
          type = lib.types.str;
          description = "Display name of the primary user.";
        };
        email = lib.mkOption {
          type = lib.types.str;
          description = "Email address used for version control identity.";
        };
        hostname = lib.mkOption {
          type = lib.types.str;
          description = "Hostname of this machine.";
        };
      };
    };
  };

  config.identity = {
    username = "toufiq";
    fullName = "Toufiq Shishir";
    email = "toufiqshishir@outlook.com";
    hostname = "toufiqspc";
  };

}
