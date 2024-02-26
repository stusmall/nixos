{ pkgs, lib, ... }:
{
  # Don't let networkmanager manage DNS settings.  We only want the DNS servers declared here
  networking.networkmanager.dns = "none";

  # Tailscale likes rewrite resovl.conf and breaks encrypted DNS.  Ensure it isn't enabled if we are trying to use this.
  services.tailscale.enable = lib.mkForce false;

  # Enabled DoH
  # pkgs.stubby.passthru.settingsExample is the example toml from the root of the github repo.  It has a series of opinionated, safe defaults
  # If the TLS keys change at some point we can get the new sha256 hashes with the following command:
  #
  # nix-shell -p knot-dns --command "kdig -d @1.0.0.2 +tls-ca +tls-host=cloudflare-dns.com example.com"
  #
  # TODO: Eventually it would be nice to replace this with trust-dns
  services.stubby = {
    enable = true;
    settings = pkgs.stubby.passthru.settingsExample // {
      upstream_recursive_servers = [{
        address_data = "1.0.0.2";
        tls_auth_name = "security.cloudflare-dns.com";
        tls_pubkey_pinset = [{
          digest = "sha256";
          value = "HdDBgtnj07/NrKNmLCbg5rxK78ZehdHZ/Uoutx4iHzY=";
        }];
      }
        {
          address_data = "1.1.1.2";
          tls_auth_name = "security.cloudflare-dns.com";
          tls_pubkey_pinset = [{
            digest = "sha256";
            value = "HdDBgtnj07/NrKNmLCbg5rxK78ZehdHZ/Uoutx4iHzY=";
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
