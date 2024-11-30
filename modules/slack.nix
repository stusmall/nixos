{ pkgs, lib, ... }:
{
  environment.systemPackages = [
    pkgs.slack
  ];

  services.opensnitch.rules = {
    rule-900-slack = {
      name = "Allow Slack Rule";
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
            data = "${lib.getBin pkgs.slack}/lib/slack/slack";
          }
        ];
      };
    };
  };
}
