{ lib, pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.spotify
  ];

  # Unforuntately Spotify doesn't publish a great way to whitelist it's traffic
  services.opensnitch.rules = {
    rule-500-spotify = {
      name = "Allow Spotify";
      enabled = true;
      action = "allow";
      duration = "always";
      operator =
        {
          type = "simple";
          sensitive = false;
          operand = "process.path";
          data = "${lib.getBin pkgs.spotify}/share/spotify/.spotify-wrapped";
        };
    };

  };
}
