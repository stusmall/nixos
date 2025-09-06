{ pkgs, lib, ... }:
{

  # This utility it what I use to update firmware on my pinetime.  It just needs to reach GitHub to fetch the newest
  # firmware.
  environment.systemPackages = with pkgs; [ watchmate ];

  services.opensnitch.rules = {
    rule-500-watchmate-github = {
      name = "Allow Watchmate reach GitHub";
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
            data = "${lib.getBin pkgs.watchmate}/bin/.watchmate-wrapped";
          }
          {
            type = "regexp";
            operand = "dest.host";
            sensitive = false;
            data = "^(api\\.github\\.com)|(objects\\.githubusercontent\\.com)$";
          }
        ];
      };
    };
  };
}
