{ lib, pkgs, ... }:



{
  home.username = "stusmall";
  home.homeDirectory = "/home/stusmall";

  home.stateVersion = "22.11";

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    alacritty
    chromium
    dig
    docker-machine
    firefox
    gnomeExtensions.appindicator
    gnomeExtensions.dash-to-dock
    gnupg
    htop
    jetbrains.clion
    jetbrains.pycharm-professional
    jetbrains.rust-rover
    jq
    kooha
    kubectl
    libreoffice-fresh
    opensnitch-ui
    openssl
    pciutils
    ripgrep
    meld
    nil
    nixpkgs-fmt
    nmap
    signal-desktop
    slack
    spotify
    tokei
    tree
    usbutils
    wireshark
    whois
    vlc
    zellij
    zoom-us
  ];

  nixpkgs.overlays = [
    (final: previous : {
      jetbrains = previous.jetbrains // {
        rust-rover = previous.jetbrains.rust-rover.overrideDerivation (_: {
          name = "rust-rover";
          version = "2023.3 EAP";
          src = previous.fetchurl {
            url = "https://download.jetbrains.com/rustrover/RustRover-233.11799.306.tar.gz";
            sha256 = "Wc1frHELFT76uUNBWUdRu1DNsd/10ikruAZ+yHCFrTU=";
          };
        });
      };
    })
  ];

  home.sessionVariables = { };

  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        # This along with explicitly setting the cursor theme helps fix my issue where I couldn't grab the side of the window to resize
        dynamic_padding = true;
      };
    };
  };

  programs.bash = {
    enable = true;
    bashrcExtra = ''
      # Include secrets managed outside nix
      source $HOME/.secrets/*
      # Always open terminal in zellij session
      eval "$(zellij setup --generate-auto-start bash)"
      # Needed to use yubkiey for SSH key
      export GPG_TTY="$(tty)"
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    '';
  };

  services.gpg-agent = {
    enable = true;
    enableScDaemon = true;
    enableSshSupport = true;
    defaultCacheTtl = 60;
    maxCacheTtl = 120;
    pinentryFlavor = "gnome3";
  };

  programs.git = {
    enable = true;
    userName = "Stu Small";
    userEmail = "stuart.alan.small@gmail.com";
    extraConfig = {
      core = {
        editor = "hx";
        compression = 9;
      };
      pull = {
        rebase = true;
      };
      push = {
        autoSetupRemote = true;
      };
    };
  };

  programs.helix = {
    enable = true;
  };

  programs.vim = {
    enable = true;
    defaultEditor = true;
    extraConfig = ''
      set number
      set nobackup nowritebackup noswapfile
    '';
  };

  programs.zellij = {
    enable = true;
    settings = {
      ui = {
        pane_frames = {
          hide_session_name = true;
        };
      };
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      # Added for: https://github.com/alacritty/alacritty/issues/4780#issuecomment-859481392
      cursor-theme = "Adwaita";
      show-battery-percentage = true;
    };
    "org/gnome/shell" = {
      enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
        "dash-to-dock@micxgx.gmail.com"
      ];
      favorite-apps = [ "Alacritty.desktop" "firefox.desktop" "clion.desktop" "pycharm-professional.desktop" ];
    };
    "org/gnome/shell/extensions/dash-to-dock" = {
      apply-custom-theme = true;
    };
  };

  # Set start up applications
  # shitty version of this https://github.com/nix-community/home-manager/issues/3447#issuecomment-1328294558
  home.file.".config/autostart/opensnitch_ui.desktop".source = (pkgs.opensnitch-ui + "/share/applications/opensnitch_ui.desktop");

  # maintain a folder to include secrets to be pulled into global envars that we don't want managed by nix
  home.activation.name = lib.hm.dag.entryAfter [ "writeBoundary"]  "mkdir -p ~/.secrets";

}

