{ lib, pkgs, ... }:
{
  imports = [
    ../modules/zoom.nix
    ../modules/slack.nix
  ];

  # This is currently breaking encrypted DNS.  It adds 100.100.100.100 to resolv.conf
  services.tailscale.enable = lib.mkForce true;


  services.opensnitch.rules = {
    # Since we have encrypted DNS disabled we should whitelist nsncd.  This is unfortunately a very broad whitelist
    rule-100-dns = {
      name = "Allow DNS from nsncd";
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
            data = "${lib.getBin pkgs.nsncd}/bin/nsncd";
          }
          {
            type = "simple";
            operand = "protocol";
            sensitive = false;
            data = "udp";
          }
          {
            type = "simple";
            operand = "dest.port";
            sensitive = false;
            data = "53";
          }
        ];
      };
    };
    # Once again unfortunately pretty broad.  We don't have great view into what tailscale will connect to or do.
    rule-100-tailscale = {
      name = "Allow tailscale";
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
            data = "${lib.getBin pkgs.tailscale}/bin/.tailscaled-wrapper";
          }
        ];
      };
    };
  };



  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
}
