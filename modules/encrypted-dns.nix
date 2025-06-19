{ pkgs, lib, ... }:
{
  # Don't let networkmanager manage DNS settings.  We only want the DNS servers declared here
  networking.networkmanager.dns = "none";

  # Enabled DoH
  # The NixOS documentation suggests added your changes to the default config, but that started breaking
  # with 25.05.  I've pulled the settings out of their file and added directly here.  Using that example
  # file seemed off, so I don't mind being more explicit here.
  services.stubby = {
    enable = true;
    settings = {
      log_level = "GETDNS_LOG_NOTICE";
      resolution_type = "GETDNS_RESOLUTION_STUB";
      tls_authentication = "GETDNS_AUTHENTICATION_REQUIRED";
      dns_transport_list = [ "GETDNS_TRANSPORT_TLS" ];
      tls_query_padding_blocksize = 128;
      edns_client_subnet_private = 1;
      round_robin_upstreams = 1;
      idle_timeout = 10000;
      listen_addresses = [ "127.0.0.1" "0::1" ];
      upstream_recursive_servers = [{
        address_data = "1.0.0.2";
        tls_auth_name = "security.cloudflare-dns.com";
      }
        {
          address_data = "1.1.1.2";
          tls_auth_name = "security.cloudflare-dns.com";
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
