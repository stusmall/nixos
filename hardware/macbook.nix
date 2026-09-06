{ pkgs, ... }:

{

  imports = [
    <home-manager/nix-darwin>
  ];

  users.knownUsers = [ "stuartsmall" ];
  users.users.stuartsmall = {
    uid = 501;
    home = "/Users/stuartsmall";
    shell = pkgs.bashInteractive;
  };
  system.primaryUser = "stuartsmall";

  home-manager.users.stuartsmall = import ../home-modules/macos-home.nix;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = [
    pkgs.helix
  ];

  system.defaults.dock.persistent-apps = [
    "/Applications/Firefox.app/"
    "/Users/stuartsmall/Applications/Home\ Manager\ Apps/Alacritty.app"
    "/Users/stuartsmall/Applications/Home\ Manager\ Apps/Zed.app"
  ];

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;
}
