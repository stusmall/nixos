# This was mostly borrowed from https://github.com/coreyoconnor/nix_configs/blob/b59dbb77ee38e515f4099f8fb0feb5e2286a5b34/modules/semi-active-av.nix
{ config, pkgs, lib, ... }:
with lib;
let
  notify-all-users = pkgs.writeScript "notify-all-users-of-av-finding"
    ''
      #!/bin/sh
      ALERT="Signature detected by clamav: $CLAM_VIRUSEVENT_VIRUSNAME in $CLAM_VIRUSEVENT_FILENAME"
      # Send an alert to all graphical users.
      for ADDRESS in /run/user/*; do
          USERID=''${ADDRESS#/run/user/}
         /run/wrappers/bin/sudo -u "#$USERID" DBUS_SESSION_BUS_ADDRESS="unix:path=$ADDRESS/bus" ${pkgs.libnotify}/bin/notify-send -i dialog-warning "Antivirus Finding" "$ALERT"
      done
    '';
in
{
  environment.systemPackages = [
    pkgs.libnotify
  ];
  security.sudo = {
    extraConfig =
      ''
        clamav ALL = (ALL) NOPASSWD: SETENV: ${pkgs.libnotify}/bin/notify-send
      '';
  };

  services.clamav.daemon = {
    enable = true;

    settings = {
      VirusEvent = "${notify-all-users}";
    };
  };
  services.clamav.updater.enable = true;


  systemd.timers.av-all-scan = {
    description = "scan all directories";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Unit = "av-all-scan.service";
    };
  };

  systemd.services.av-all-scan = {
    description = "scan all directories";
    after = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        ${pkgs.systemd}/bin/systemd-cat --identifier=av-scan ${pkgs.clamav}/bin/clamdscan --quiet --recursive --fdpass /
      '';
    };
  };

}
