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
    firefox
    gnupg
    htop
    jq
    kooha
    kubectl
    libreoffice-fresh
    openssl
    pciutils
    ripgrep
    meld
    nil
    nixpkgs-fmt
    nmap
    tokei
    tree
    usbutils
    whois
    vlc
    zellij
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
      init = {
        defaultBranch = "main";
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
    "org/gnome/desktop/screensaver" = {
      lock-enabled = true;
    };
    # TODO: verify
    # Screen blanks after 15 minutes
    "org/gnome/desktop/session" = {
      idle-delay = 900;
    };
    "org/gnome/desktop/notifications" = {
      show-in-lock-screen = false;
    };
    # TODO: verify
    # Suspend after 15 minutes
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-timeout = 900;
    };
    "org/gnome/shell" = {
      enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
        "dash-to-dock@micxgx.gmail.com"
      ];
      favorite-apps = [
        "Alacritty.desktop"
        "firefox.desktop"
        "rust-rover.desktop"
        "pycharm-professional.desktop"
        "signal-desktop.desktop"
      ];
    };
    "org/gnome/shell/extensions/dash-to-dock" = {
      apply-custom-theme = true;
    };
  };


  # maintain a folder to include secrets to be pulled into global envars that we don't want managed by nix
  home.activation.name = lib.hm.dag.entryAfter [ "writeBoundary" ] "mkdir -p ~/.secrets";


}

