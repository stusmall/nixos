{ pkgs, lib, ... }:
{

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment.systemPackages = with pkgs.gnomeExtensions; [
    appindicator
    dash-to-dock
  ];


  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    atomix
    caribou
    cheese
    geary
    epiphany
    gnome-calendar
    gnome-characters
    gnome-clocks
    gnome-dictionary
    gnome-font-viewer
    gnome-keyring
    gnome-maps
    gnome-music
    gnome-remote-desktop
    gnome-terminal
    gnome-weather
    hitori
    iagno
    tali
    totem
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
            data = "${lib.getBin pkgs.gnome.gnome-calculator}/bin/.gnome-calculator-wrapped";
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
