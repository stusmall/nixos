{ pkgs, lib, ... }:
let steamRegex = "^/home/stusmall/.local/share/Steam/ubuntu12_32/steam|/home/stusmall/.local/share/Steam/ubuntu12_64/steamwebhelper$"; in

{
  environment.systemPackages = with pkgs; [
    steam
  ];

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
            type = "simple";
            operand = "dest.host";
            sensitive = false;
            data = "192.168.1.255";
          }
        ];
      };
    };
    rule-600-steam-static-content = {
      name = "Allow Steam to fetch static content";
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
            data = "^([a-z0-9|-]+\\.)*steamstatic\\.com$";
          }
        ];
      };
    };
    rule-600-steam-api = {
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
            data = "^([a-z0-9|-]+\\.)*(steampowered\\.com|steamcommunity\\.com|steamserver\\.net)$";
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
            type = "simple";
            operand = "dest.host";
            sensitive = false;
            data = "update.googleapis.com";
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
