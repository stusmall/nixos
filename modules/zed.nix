{ pkgs, lib, ... }:
{
  environment.systemPackages = [
    pkgs.rust-analyzer
    pkgs.zed-editor
  ];

  services.opensnitch.rules = {
    rule-500-zed = {
      name = "Allow zed to phone home";
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
            data = "${lib.getBin pkgs.zed-editor}/libexec/.zed-editor-wrapped";
          }
          {
            type = "regexp";
            operand = "dest.host";
            sensitive = false;
            data = "^([a-z0-9|-]+\\.)*zed.dev$";
          }
        ];
      };
    };
    rule-500-zed-gihutb = {
      name = "Allow zed to access GitHub";
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
            data = "${lib.getBin pkgs.zed-editor}/libexec/.zed-editor-wrapped";
          }
          {
            type = "regexp";
            operand = "dest.host";
            sensitive = false;
            data = "^((([a-z0-9|-]+\\.)*github\\.com)|(([a-z0-9|-]+\\.)*raw\\.githubusercontent\\.com))$";
          }
        ];
      };
    };
  };
}
