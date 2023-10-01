{ config, lib, pkgs, ... }:

{
  imports =
    [
      <home-manager/nixos>
      # This needs to link to the the absolute path and not a relative path.   We don't know which hardware config the bootstrap script picked so we need to use that symlink
      /etc/nixos/hardware-configuration.nix
    ];

  # Use the newest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Enable networking
  networking.networkmanager.enable = true;

  # Don't let networkmanager manage DNS settings.  We only want the DNS servers declared here
  networking.networkmanager.dns = "none";

  # Enabled DoH
  # pkgs.stubby.passthru.settingsExample is the example toml from the root of the github repo.  It has a series of opinionated, safe defaults
  # TODO: Eventually it would be nice to replace this with trust-dns
  services.stubby = {
    enable = true;
    settings = pkgs.stubby.passthru.settingsExample // {
      upstream_recursive_servers = [{
        address_data = "1.0.0.2";
        tls_auth_name = "security.cloudflare-dns.com";
        tls_pubkey_pinset = [{
          digest = "sha256";
          value = "GP8Knf7qBae+aIfythytMbYnL+yowaWVeD6MoLHkVRg=";
        }];
      } {
        address_data = "1.1.1.2";
        tls_auth_name = "security.cloudflare-dns.com";
        tls_pubkey_pinset = [{
          digest = "sha256";
          value = "GP8Knf7qBae+aIfythytMbYnL+yowaWVeD6MoLHkVRg=";
        }];
      }];
    };
  };


  # Set your time zone.
  time.timeZone = "America/Denver";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

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
          list = [];
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
              data =  "${lib.getBin pkgs.avahi}/bin/avahi-daemon";
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
              data =  "${lib.getBin pkgs.avahi}/bin/avahi-daemon";
            }
            {
              type = "simple";
              operand = "dest.ip";
              data = "ff02::fb";
            }];
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
              type ="simple";
              sensitive = false;
              operand = "process.path";
              data = "${lib.getBin pkgs.systemd}/lib/systemd/systemd-timesyncd";
            }
            {
              type = "regexp";
              operand = "dest.host";
              data = ".*\\.nixos\\.pool\\.ntp\\.org";
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
              data = "^(github\.com|nixos\.org|.*nixos\.org)$";
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
              data = "^.*signal\.org$";
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
        name = "Allow Jetbrains tools to phone home";
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
              data = "^.*jetbrains\.com$";
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
  
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.stusmall = {
    isNormalUser = true;
    description = "Stuart Small";
    extraGroups = [ "networkmanager" "wireshark" "wheel" ];
  };

  # Define the wireshark group and set dumpcap with it.  This allows us to capture as nonroot
  # The wireshark package won't do this for us
  users.groups.wireshark = {};
  security.wrappers.dumpcap = {
    source = "${pkgs.wireshark}/bin/dumpcap";
    permissions = "u+xs,g+x";
    owner = "root";
    group = "wireshark";
  };

  # Make nixos-rebuild invoke home-manager
  home-manager.users.stusmall = import /home/stusmall/.config/home-manager/home.nix;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  home-manager.useGlobalPkgs = true;

  # Enable auto-upgrades.  By default it is run daily
  system.autoUpgrade.enable = true;
  
  environment.systemPackages = with pkgs; [
    home-manager
    gnomeExtensions.appindicator
    gnomeExtensions.dash-to-dock
    vim
  ];

  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    cheese
    gnome-music
    gnome-terminal
    epiphany
    geary
    gnome-characters
    totem
    tali
    iagno
    hitori
    atomix
  ]);

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
