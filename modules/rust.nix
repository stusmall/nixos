{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    clang
    rustup
  ];

  services.opensnitch.rules = {
    rule-500-cargo = {
      name = "Allow cargo to reach needed sites";
      enabled = true;
      action = "allow";
      duration = "always";
      operator = {
        type = "list";
        operand = "list";
        list = [
          {
            type = "regexp";
            sensitive = false;
            operand = "process.path";
            data = "^(/home/stusmall/.rustup/toolchains/(.*)/bin/cargo)|(${lib.getBin pkgs.cargo}/bin/cargo)$";
          }
          {
            type = "regexp";
            operand = "dest.host";
            sensitive = false;
            data = "^(([a-z0-9|-]+\.)*crates\.io)|(([a-z0-9|-]+\.)*github\.com)$";
          }
        ];
      };
    };
    rule-500-rustup = {
      name = "Allow rustup to reach needed sites";
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
            data = "${lib.getBin pkgs.rustup}/bin/.rustup-wrapped";
          }
          {
            type = "simple";
            operand = "dest.host";
            sensitive = false;
            data = "static.rust-lang.org";
          }
        ];
      };
    };
  };
}
