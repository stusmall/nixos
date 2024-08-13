{ pkgs, lib, ... }:
{
  environment.systemPackages = [
    pkgs.slack
  ];

  services.opensnitch.rules = {
    rule-900-slack-1 = {
      name = "Allow Slack Rule 1";
      enabled = true;
      action = "allow";
      duration = "always";
      operator = {
        type = "list";
        operand = "list";
        list = [
          {
            type = "simple";
            operand = "process.path";
            sensitive = false;
            data = "${lib.getBin pkgs.zoom-us}/bin/avahi-daemon";
          }
          {
            type = "network";
            operand = "dest.network";
            data = "3.7.35.0/25";
          }
        ];
      };
    };
  };
}
