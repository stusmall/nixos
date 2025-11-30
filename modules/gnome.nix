{ pkgs, ... }:
{
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  environment.systemPackages = with pkgs.gnomeExtensions; [
    appindicator
    dash-to-dock
  ];

  environment.gnome.excludePackages = (
    with pkgs;
    [
      epiphany
      geary
      gnome-calendar
      gnome-characters
      gnome-clocks
      gnome-font-viewer
      gnome-keyring
      gnome-maps
      gnome-music
      gnome-remote-desktop
      gnome-photos
      gnome-terminal
      gnome-tour
      yelp
    ]
  );
}
