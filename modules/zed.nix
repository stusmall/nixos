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
  # Zed configuration is set up in home.nix
  services.opensnitch.rules = {
    rule-500-zed = {
      name = "Allow zed to phone home";
      enable = true;
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
            data = lib.getExe unstable_pkgs.zed-editor;
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
      enable = true;
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
            data = lib.getExe unstable_pkgs.zed-editor;
          }
          {
            type = "regexp";
            operand = "dest.host";
            sensitive = false;
            data = "^((([a-z0-9|-]+\\.)*github\\.com)|(([a-z0-9|-]+\\.)*\\.githubusercontent\\.com))$";
          }
        ];
      };
    };
  };
}
