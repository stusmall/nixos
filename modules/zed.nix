{ pkgs, lib, ... }:
let
  unstable_pkgs = import (pkgs.fetchgit {
    name = "nixpkgs-unstable-aug-29-2025";
    url = "https://github.com/nixos/nixpkgs/";
    rev = "604f22e0304b679e96edd9f47cbbfc4d513a3751";
    hash = "sha256-9+O/hi9UjnF4yPjR3tcUbxhg/ga0OpFGgVLvSW5FfbE=";
  }) { };
in
{
  environment.systemPackages = [
    unstable_pkgs.zed-editor
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
            data = "${unstable_pkgs.zed-editor}/libexec/.zed-editor-wrapped";
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
            data = "${unstable_pkgs.zed-editor}/libexec/.zed-editor-wrapped";
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
    #/nix/store/9d235766g7alzlalw4z8yqxql0jl2mgd-nodejs-22.18.0/bin/node
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
            data = "${unstable_pkgs.nodejs}/bin/node";
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
  };
}
