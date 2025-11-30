{ pkgs, lib, ... }:
{
  environment.systemPackages = [
    pkgs.zed-editor
    # Zed uses for displaying exact versions in a package.json
    pkgs.package-version-server
  ];
  # Zed configuration is set up in home.nix
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
            data = "${pkgs.zed-editor}/libexec/.zed-editor-wrapped";
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
    rule-500-zed-github = {
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
            data = "${pkgs.zed-editor}/libexec/.zed-editor-wrapped";
          }
          {
            type = "regexp";
            operand = "dest.host";
            sensitive = false;
            data = "^((([a-z0-9|-]+\\.)*github\.com)|(([a-z0-9|-]+\\.)*\.githubusercontent\.com))$";
          }
        ];
      };
    };

    rule-500-zeds-npm = {
      name = "Allow zed's npm to reach needed sites";
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
            data = "${pkgs.nodejs}/bin/node";
          }
          {
            type = "regexp";
            operand = "dest.host";
            sensitive = false;
            data = "^(registry\\.npmjs\\.org)|(([a-z0-9|-]+\\.)*schemastore\\.org)$";
          }
        ];
      };
    };
    rule-500-package-language-server = {
      name = "Allow package langauge server to contact npm";
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
            data = lib.getExe pkgs.package-version-server;
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
    rule-500-zed-extensions = {
      name = "Allow zed to pull extensions";
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
            data = "${pkgs.zed-editor}/libexec/.zed-editor-wrapped";
          }
          {
            type = "simple";
            operand = "dest.host";
            sensitive = false;
            data = "zed-extensions.nyc3.digitaloceanspaces.com";
          }
        ];
      };
    };
  };
}
