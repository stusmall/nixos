{ config, pkgs, lib, ... }:
{
  services.opensnitch = {
    enable = true;
    settings.DefaultAction = "deny";
    rules = {
      rule-000-localhost = {
        name = "Allow all localhost";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type = "regexp";
          operand = "dest.ip";
          sensitive = false;
          data = "^(127\\.0\\.0\\.1|::1)$";
          list = [ ];
        };
      };
      rule-001-avahi-ipv4 = {
        name = "Allow avahi daemon IPv4";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type = "list";
          operand = "list";
          list = [
            {
              type = "simple";
              operand = "process.path";
              sensitive = false;
              data = "${lib.getBin pkgs.avahi}/bin/avahi-daemon";
            }
            {
              type = "network";
              operand = "dest.network";
              data = "224.0.0.0/24";
            }
          ];
        };
      };
      rule-002-avahi-ipv6 = {
        name = "Allow avahi daemon IPv6";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type = "list";
          operand = "list";
          list = [
            {
              type = "simple";
              operand = "process.path";
              sensitive = false;
              data = "${lib.getBin pkgs.avahi}/bin/avahi-daemon";
            }
            {
              type = "simple";
              operand = "dest.ip";
              data = "ff02::fb";
            }
          ];
        };
      };
      rule-003-ntp = {
        name = "Allow NTP";
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
              data = "${lib.getBin pkgs.systemd}/lib/systemd/systemd-timesyncd";
            }
            {
              type = "simple";
              operand = "dest.port";
              sensitive = false;
              data = "123";
            }
            {
              type = "simple";
              operand = "protocol";
              sensitive = false;
              data = "udp";
            }
          ];
        };
      };
      rule-004-dns-over-https = {
        name = "Allow encrypted DNS to Cloudflare";
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
              data = "${lib.getBin pkgs.stubby}/bin/stubby";
            }
            {
              type = "regexp";
              operand = "dest.ip";
              sensitive = false;
              data = "^(1\\.0\\.0\\.2|1\\.1\\.1\\.2)$";
            }
          ];
        };
      };
      rule-005-nix-update = {
        name = "Allow Nix";
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
              data = "${lib.getBin pkgs.nix}/bin/nix";
            }
            {
              type = "regexp";
              operand = "dest.host";
              sensitive = false;
              data = "^(([a-z0-9|-]+\.)*github\.com|([a-z0-9|-]+\.)*nixos\.org)$";
            }
          ];
        };
      };
      rule-006-signal = {
        name = "Allow Signal";
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
              data = "${lib.getBin pkgs.signal-desktop}/lib/Signal/signal-desktop";
            }
            {
              type = "regexp";
              operand = "dest.host";
              sensitive = false;
              data = "^([a-z0-9|-]+\.)*signal\.org$";
            }
          ];
        };
      };
      rule-007-NetworkManager = {
        name = "Allow NetworkManager";
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
              data = "${lib.getBin pkgs.networkmanager}/bin/NetworkManager";
            }
            {
              type = "simple";
              operand = "dest.port";
              sensitive = false;
              data = "67";
            }
            {
              type = "simple";
              operand = "protocol";
              sensitive = false;
              data = "udp";
            }
          ];
        };
      };
      rule-008-jetbrains = {
        name = "Allow Jetbrains tools";
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
              data = "${lib.getBin pkgs.jetbrains.jdk}/lib/openjdk/bin/java";
            }
            {
              type = "regexp";
              operand = "dest.host";
              sensitive = false;
              data = "^(([a-z0-9|-]+\.)jetbrains\.com|github\.com|([a-z0-9|-]+\.)schemastore.org)$";
            }
          ];
        };
      };
      rule-009-gnome-calc = {
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
      rule-010-freshclam = {
        name = "Allow clamav to update signatures";
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
              data = "${lib.getBin pkgs.clamav}/bin/freshclam";
            }
            {
              type = "simple";
              operand = "dest.host";
              sensitive = false;
              data = "database.clamav.net";
            }
          ];
        };
      };
      rule-999-firefox = {
        name = "Allow Firefox";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type = "simple";
          sensitive = false;
          operand = "process.path";
          data = "${lib.getBin pkgs.firefox}/lib/firefox/firefox";
        };
      };
    };
  };
}
