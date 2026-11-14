{ self, inputs, config, ... }:
let
  identity = config.identity;
in
{

  flake.nixosModules.ssh = { ... }: {
    # OpenSSH server. Password authentication is on so the first login from a
    # phone works without pre-installing a key; turn it off once a key is
    # deployed (see the note below).
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = true;
        KbdInteractiveAuthentication = false;
      };
    };

    # Tailnet traffic is already trusted by the firewall (see networking.nix),
    # and services.openssh.openFirewall (default) opens port 22 on the LAN too.
    #
    # Deploy a key, then set PasswordAuthentication = false above:
    # users.users.${identity.username}.openssh.authorizedKeys.keys = [
    #   "ssh-ed25519 AAAA... you@phone"
    # ];
  };

}
