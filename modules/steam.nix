{ pkgs, lib, ... }:
let
  steamRegex = "^/home/stusmall/\\.local/share/Steam/ubuntu12_32/steam|/home/stusmall/\\.local/share/Steam/ubuntu12_64/steamwebhelper$";

in
{
  environment.systemPackages = with pkgs; [ steam ];

  # We need 32bit versions of all the OpenGL etc libraries for steam to run
  hardware.graphics.enable32Bit = true;

  programs.steam = {
    remotePlay.openFirewall = true;
  };

  services.opensnitch.rules = {
    rule-600-steam-lan = {
      name = "Allow Steam to reach out on LAN";
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
            data = "/home/stusmall/.local/share/Steam/ubuntu12_32/steam";
          }
          {
            type = "network";
            operand = "dest.network";
            data = "192.168.1.0/24";
          }
          {
            type = "simple";
            operand = "dest.port";
            sensitive = false;
            data = "27036";
          }

        ];
      };
    };
    rule-600-steam-akamaihd = {
      name = "Allow Steam to reach akamaihd";
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
            data = "/home/stusmall/.local/share/Steam/ubuntu12_64/steamwebhelper";
          }
          {
            type = "simple";
            operand = "dest.host";
            sensitive = false;
            data = "steamcommunity-a.akamaihd.net";
          }
        ];
      };
    };
    rule-600-steam-to-steam-domain = {
      name = "Allow Steam to reach steam domains";
      enabled = true;
      action = "allow";
      duration = "always";
      operator = {
        type = "list";
        operand = "list";
        list = [
          {
            type = "regexp";
            sensitive = false;
            operand = "process.path";
            data = steamRegex;
          }
          {
            type = "regexp";
            operand = "dest.host";
            sensitive = false;
            data = "^([a-z0-9|-]+\\.)*(steampowered\\.com|steamcommunity\\.com|steamserver\\.net|steamstatic\\.com|steamcontent\\.com)$";
          }
        ];
      };
    };
    rule-600-steam-webhelper-google = {
      name = "Allow Steam web helper to reach google APIs";
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
            data = "/home/stusmall/.local/share/Steam/ubuntu12_64/steamwebhelper";
          }
          {
            type = "regexp";
            operand = "dest.host";
            sensitive = false;
            data = "^(update|steamcloud-us-east1\\.storage\\.)\\.googleapis\\.com$";
          }
        ];
      };
    };
    rule-600-steam-webhelper-youtube = {
      name = "Allow Steam web helper to reach youtube";
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
            data = "/home/stusmall/.local/share/Steam/ubuntu12_64/steamwebhelper";
          }
          {
            type = "simple";
            operand = "dest.host";
            sensitive = false;
            data = "www.youtube.com";
          }
        ];
      };
    };
  };
}
