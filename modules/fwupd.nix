{ pkgs, ... }:
{
  services.fwupd.enable = true;

  services.opensnitch.rules = {
    rule-500-fwupd = {
      name = "Allow fwupd to phone home";
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
            data = "${pkgs.fwupd}/bin/.fwupdmgr-wrapped";
          }
          {
            type = "simple";
            operand = "dest.host";
            sensitive = false;
            data = "cdn.fwupd.org";
          }
        ];
      };
    };
  };
}
