{ self, inputs, config, ... }:
let
  identity = config.identity;
in
{

  flake.nixosModules.docker = { config, ... }: {
    # Rootless Docker: a per-user dockerd managed by a systemd user service.
    # It starts on login and stops at logout (no linger).
    virtualisation.docker.rootless = {
      enable = true;
      # Fallback for shells: unix://$XDG_RUNTIME_DIR/docker.sock.
      setSocketVariable = true;
    };

    # GUI apps and IDEs launched outside a login shell need DOCKER_HOST at
    # session level too.
    environment.sessionVariables.DOCKER_HOST =
      "unix:///run/user/${toString config.users.users.${identity.username}.uid}/docker.sock";
  };

}
