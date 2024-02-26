{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    steam
  ];

}
