{ self, inputs, config, ... }:
let
  identity = config.identity;
in
{

  flake.nixosModules.networking = { ... }: {
    networking.hostName = identity.hostname;

    # Enable networking.
    networking.networkmanager.enable = true;

    # Tailscale daemon (tailscaled) plus the tailscale CLI. The device is
    # enrolled once per install with `sudo tailscale up`; the state lives in
    # /var/lib/tailscale and survives rebuilds.
    services.tailscale.enable = true;

    # Traffic arriving over the tailnet is already authenticated by Tailscale,
    # so let it through the firewall without per-port rules.
    networking.firewall.trustedInterfaces = [ "tailscale0" ];
  };

}
