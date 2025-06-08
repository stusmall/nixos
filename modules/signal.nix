{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    signal-desktop-bin
  ];

  services.opensnitch.rules = {
    rule-500-signal = {
      name = "Allow Signal";
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
            data = "${lib.getBin pkgs.signal-desktop-bin}/lib/signal-desktop/signal-desktop";
          }
          {
            type = "regexp";
            operand = "dest.host";
            sensitive = false;
            data = "^([a-z0-9|-]+\\.)*signal\\.org$";
          }
        ];
      };
    };
  };
}
