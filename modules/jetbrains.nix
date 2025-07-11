{ pkgs, lib, ... }:
let ideRegex = "^(${lib.getBin pkgs.jetbrains.rust-rover}/rust-rover/bin/\\.rustrover-wrapped)|(${lib.getBin pkgs.jetbrains.webstorm}/webstorm/bin/\\.webstorm-wrapped)$"; in
{
  environment.systemPackages = with pkgs.jetbrains; [
    rust-rover
    webstorm
  ];

  services.opensnitch.rules = {
    rule-500-jetbrains-to-jetbrains = {
      name = "Allow Jetbrains tools to phone home";
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
            data = ideRegex;
          }
          {
            type = "regexp";
            operand = "dest.host";
            sensitive = false;
            data = "^(([a-z0-9|-]+\\.)*jetbrains\\.com)|(([a-z0-9|-]+\\.)*intellij\\.net)$";
          }
        ];
      };
    };
    rule-500-jetbrains-to-github = {
      name = "Allow Jetbrains tools to reach GitHub";
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
            data = ideRegex;
          }
          {
            type = "regexp";
            operand = "dest.host";
            sensitive = false;
            data = "^(github\\.com|raw\\.githubusercontent\\.com)$";
          }
        ];
      };
    };

    rule-500-jetbrains-to-npm = {
      name = "Allow Jetbrains tools to contact npm";
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
            data = ideRegex;
          }
          {
            type = "simple";
            operand = "dest.host";
            sensitive = false;
            data = "registry.npmjs.org";
          }
        ];
      };
    };
    rule-500-jetbrains-to-schemastore = {
      name = "Allow Jetbrains tools to reach schemastore";
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
            data = ideRegex;
          }
          {
            type = "regexp";
            operand = "dest.host";
            sensitive = false;
            data = "^([a-z0-9|-]+\\.)*schemastore\\.org$";
          }
        ];
      };
    };
    rule-500-jetbrains-to-pypi = {
      name = "Allow Jetbrains tools to reach out to pypi";
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
            data = ideRegex;
          }
          {
            type = "regexp";
            operand = "dest.host";
            sensitive = false;
            data = "^pypi\\.python.org|pypi\\.org$";
          }
        ];
      };
    };
    rule-500-deny-jetbrains-ai = {
      name = "Deny jetbrains AI access";
      enabled = true;
      action = "deny";
      duration = "always";
      operator = {
        type = "list";
        operand = "list";
        list = [
          {
            type = "regexp";
            sensitive = false;
            operand = "process.path";
            data = ideRegex;
          }
          {
            type = "simple";
            operand = "dest.host";
            sensitive = false;
            data = "api.jetbrains.ai";
          }
        ];
      };
    };
  };
}
