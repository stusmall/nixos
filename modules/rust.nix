{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    clang
    rustup
  ];

  services.opensnitch.rules = {
    rule-500-cargo = {
      name = "Allow cargo to reach crates.io";
      enabled = true;
      action = "allow";
      duration = "always";
      operator = {
        type = "list";
        operand = "list";
        list = [
          {
            type = "regex";
            sensitive = false;
            operand = "process.path";
            data = "^/home/stusmall/.rustup/toolchains/*/bin/cargo$";
          }
          {
            type = "regexp";
            operand = "dest.host";
            sensitive = false;
            data = "^(([a-z0-9|-]+\.)*crates\.io)$";
          }
        ];
      };
    };
  };
}
