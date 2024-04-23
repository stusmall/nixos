{ config, pkgs, lib, ... }:
let
  url = import ../unstable_url.nix;
  unstable = import
    (builtins.fetchTarball url)
    { config = config.nixpkgs.config; };
in
{
  environment.systemPackages = with pkgs.jetbrains; [
    pycharm-professional
    unstable.jetbrains.rust-rover
  ];

  services.opensnitch.rules = {
    rule-500-jetbrains = {
      name = "Allow Jetbrains tools";
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
            data = "${lib.getBin pkgs.jetbrains.jdk}/lib/openjdk/bin/java";
          }
          {
            type = "regexp";
            operand = "dest.host";
            sensitive = false;
            data = "^(([a-z0-9|-]+\.)*jetbrains\.com|github\.com|([a-z0-9|-]+\.)*schemastore.org)$";
          }
        ];
      };
    };
  };
}
