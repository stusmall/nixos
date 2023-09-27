{ config, lib, pkgs, ... }:

{
  imports =
    [
      <home-manager/nixos>
      /etc/nixos/hardware-configuration.nix
    ];

  # Use the newest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Enable networking
  networking.networkmanager.enable = true;

  # Don't let networkmanager manage DNS settings.  We only want the DNS servers declared here
  networking.networkmanager.dns = "none";

  services.dnscrypt-proxy2 = {
    enable = true;
    settings = {
      # To simplify opensnitch rules we want to know our bootstrap resolvers
      bootstrap_resolvers = ["1.0.0.2:53" "1.1.1.2:53" ];
      ipv6_servers = true;
      require_dnssec = true;
      # These values are pulled from https://github.com/DNSCrypt/dnscrypt-resolvers/blob/247e1ad7642ccf2154329373daf5908c64efaeb0/v3/public-resolvers.md?plain=1#L446
      # But with one minor change for some reason it only lists 1.0.0.2 and leaves out 1.1.1.2.  These static entries fix that.
      # To view or edit stamp entries use: https://dnscrypt.info/stamps/
      # To test if the security protection works goto: https://phishing.testcategory.com or https://malware.testcategory.com/
      static = {
        cloudflare-security-1 = {
          stamp = "sdns://AgMAAAAAAAAABzEuMS4xLjIAG3NlY3VyaXR5LmNsb3VkZmxhcmUtZG5zLmNvbQovZG5zLXF1ZXJ5";
        };
        cloudflare-security-2 = {
          stamp = "sdns://AgMAAAAAAAAABzEuMC4wLjIAG3NlY3VyaXR5LmNsb3VkZmxhcmUtZG5zLmNvbQovZG5zLXF1ZXJ5";
        };
        cloudflare-security-ipv6-1 = {
          stamp = "sdns://AgcAAAAAAAAAFlsyNjA2OjQ3MDA6NDcwMDo6MTExMV0AIDFkb3QxZG90MWRvdDEuY2xvdWRmbGFyZS1kbnMuY29tCi9kbnMtcXVlcnk";
        };
        cloudflare-security-ipv6-2 = {
          stamp = "sdns://AgcAAAAAAAAAFlsyNjA2OjQ3MDA6NDcwMDo6MTAwMV0AIDFkb3QxZG90MWRvdDEuY2xvdWRmbGFyZS1kbnMuY29tCi9kbnMtcXVlcnk";
        };
      };
      server_names = [
        "cloudflare-security-1"
        "cloudflare-security-2"
        "cloudflare-security-ipv6-1"
        "cloudflare-security-ipv6-2"
      ];
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
      rule-004-ntp = {
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
      rule-004-bootstrap-dns = {
        name = "Bootstrap DNS";
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
              data = "${lib.getBin pkgs.dnscrypt-proxy2}/bin/dnscrypt-proxy";
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
      rule-005-dns = {
        name = "Allow DNS";
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
              data = "${lib.getBin pkgs.dnscrypt-proxy2}/bin/dnscrypt-proxy";
            }
            {
              type = "regexp";
              operand = "dest.host";
              sensitive = false;
              data = "^(raw.githubusercontent.com|download.dnscrypt.info|security.cloudflare-dns.com)$";
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
    extraGroups = [ "networkmanager" "wheel" "wireshark" ];
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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
