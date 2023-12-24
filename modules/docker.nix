{ pkgs, ... }:
{
  virtualisation.docker.enable = true;
  users.users.stusmall.extraGroups = [ "docker" ];

  environment.systemPackages = [
    pkgs.docker-machine
  ];
}
