{ pkgs, lib, ... }:
{
  # Don't let networkmanager manage DNS settings.  We only want the DNS servers declared here
  networking.networkmanager.dns = "none";

  # Tailscale likes rewrite resovl.conf and breaks encrypted DNS.  Ensure it isn't enabled if we are trying to use this.
  services.tailscale.enable = lib.mkForce false;

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

  services.opensnitch.rules = {
    rule-500-dns-over-https = {
      name = "Allow encrypted DNS to Cloudflare";
      enabled = true;
      action = "allow";
      duration = "always";
      operator = {
        type = "list";
        operand = "list";
        list = [
          {
            type = "simple";
            sensitive = false;
            operand = "process.path";
            data = "${lib.getBin pkgs.stubby}/bin/stubby";
          }
          {
            type = "regexp";
            operand = "dest.ip";
            sensitive = false;
            data = "^(1\\.0\\.0\\.2|1\\.1\\.1\\.2)$";
          }
        ];
      };
    };
  };
}
