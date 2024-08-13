{ lib, pkgs, ... }:
{
  imports = [
    ../modules/zoom.nix
    ../modules/slack.nix
  ];

  # This is currently breaking encrypted DNS.  It adds 100.100.100.100 to resolv.conf
  services.tailscale.enable = lib.mkForce true;



  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  services.opensnitch.rules = {
    rule-012-cargo = {
      name = "Allow cargo";
      enable = true;
      action = "allow";
      duration = "always";
      operator = {
        type = "list";
        operand = "list";
        list = [
          {
            type = "regexp";
            operand = "process.path";
            # Since we might have multiple rust versions installed we can't work off the exact path
            data = ".*cargo$";
          }
          {
            type = "regexp";
            operand = "dest.host";
            sensitive = false;
            data = "^(([a-z0-9|-]+\.)*crates\.io|github\.com|)$";
          }

        ];
      };
    };
    rule-013-curl = {
      # name = "Allow some expected curl desinations from work flake";
      enable = true;
      action = "allow";
      operator = {
        type = "list";
        operand = "list";
        list = [
          {
            type = "simple";
            sensitive = false;
            operand = "process.path";
            data = "${lib.getBin pkgs.curl}/bin/curl";
          }
          {
            type = "simple";
            operand = "dest.host";
            sensitive = false;
            data = "tarballs.nixos.org";
          }
        ];
      };
    };
  };
}
