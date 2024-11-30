{ pkgs, lib, ... }:
{

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment.systemPackages = with pkgs.gnomeExtensions; [
    appindicator
    dash-to-dock
  ];


  environment.gnome.excludePackages = (with pkgs; [
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
  ]);

  services.opensnitch.rules = {
    rule-500-gnome-calc = {
      name = "Allow Gnome Calculator to fetch currency conversion rates";
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
            data = "${lib.getBin pkgs.gnome-calculator}/bin/.gnome-calculator-wrapped";
          }
          {
            type = "regexp";
            operand = "dest.host";
            sensitive = false;
            data = "^(www\.ecb\.europa\.eu|www\.imf\.org)$";
          }
        ];
      };
    };
  };
}
