{ pkgs, ... }:
{
  imports = [
    ./base.nix
    ./cosmic.nix
  ];

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    aircrack-ng
    chromium
    evince
    openssl
    pciutils
    meld
    mission-center
    usbutils
    whois
    vlc
  ];

  home.stateVersion = "25.11";
}
