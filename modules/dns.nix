{ config, pkgs, lib, ... }:
{
  # Don't let networkmanager manage DNS settings.  We only want the DNS servers declared here
  networking.networkmanager.dns = "none";


  # Enabled DoH
  # pkgs.stubby.passthru.settingsExample is the example toml from the root of the github repo.  It has a series of opinionated, safe defaults
  # TODO: Eventually it would be nice to replace this with trust-dns
  services.stubby = {
    enable = true;
    settings = pkgs.stubby.passthru.settingsExample // {
      upstream_recursive_servers = [{
        address_data = "1.0.0.2";
        tls_auth_name = "security.cloudflare-dns.com";
        tls_pubkey_pinset = [{
          digest = "sha256";
          value = "GP8Knf7qBae+aIfythytMbYnL+yowaWVeD6MoLHkVRg=";
        }];
      }
        {
          address_data = "1.1.1.2";
          tls_auth_name = "security.cloudflare-dns.com";
          tls_pubkey_pinset = [{
            digest = "sha256";
            value = "GP8Knf7qBae+aIfythytMbYnL+yowaWVeD6MoLHkVRg=";
          }];
        }];
    };
  };
}
