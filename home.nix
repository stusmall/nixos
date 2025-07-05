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
    evince
    gnupg
    htop
    jq
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
    trivy
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
      # Always open terminal in zellij session
      eval "$(zellij setup --generate-auto-start bash)"
      # Needed to use yubkiey for SSH key
      export GPG_TTY="$(tty)"
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    '';
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  services.gpg-agent = {
    enable = true;
    enableScDaemon = true;
    enableSshSupport = true;
    defaultCacheTtl = 60;
    maxCacheTtl = 120;
    pinentry.package = pkgs.pinentry-gnome3;
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

  programs.zed-editor = {
    enable = true;
    extensions = [ "nix" ];
    userSettings = {
      languages = {
        Nix = {
          formatter = {
            external = {
              command = "nixpkgs-fmt";
            };
          };
          language_servers = [ "nil" "!nixd" ];
        };
      };
      telemetry = {
        metrics = false;
        diagnostics = false;
      };
    };
  };

  programs.zellij = {
    enable = true;
    settings = {
      show_startup_tips = false;
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
    # Screen blanks after 15 minutes
    "org/gnome/desktop/session" = {
      idle-delay = lib.hm.gvariant.mkUint32 900;
    };
    "org/gnome/desktop/notifications" = {
      show-in-lock-screen = false;
    };
    # Use stacked area chart to better show utilization in systems with many CPUs
    "org/gnome/gnome-system-monitor" = {
      cpu-stacked-area-chart = true;
    };
    # Suspend after 15 minutes
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "suspend";
      sleep-inactive-ac-timeout = 900;
      sleep-inactive-battery-type = "suspend";
      sleep-inactive-battery-timeout = 900;
    };
    "org/gnome/shell" = {
      enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
        "dash-to-dock@micxgx.gmail.com"
      ];
      favorite-apps = [
        "Alacritty.desktop"
        "firefox.desktop"
        "signal-desktop.desktop"
        "dev.zed.Zed.desktop"
        "rust-rover.desktop"
        "webstorm.desktop"
      ];
    };
    "org/gnome/shell/extensions/dash-to-dock" = {
      apply-custom-theme = true;
    };
    "org/gnome/system/location" = {
      enabled = false;
    };
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = "firefox.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";

  };
}
