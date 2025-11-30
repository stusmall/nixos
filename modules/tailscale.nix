{ pkgs, lib, ... }:
{
  services.tailscale.enable = true;

  services.opensnitch.rules = {
    rule-500-tailscale = {
      name = "Allow Tailscale to reach control plane";
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
            data = "${lib.getBin pkgs.tailscale}/bin/.tailscaled-wrapped";
          }
        ];
      };
    };
  };
}
