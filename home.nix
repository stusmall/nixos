{ lib, pkgs, ... }:
let
  unstable_pkgs = import (pkgs.fetchgit {
    name = "nixpkgs-unstable-aug-29-2025";
    url = "https://github.com/nixos/nixpkgs/";
    rev = "604f22e0304b679e96edd9f47cbbfc4d513a3751";
    hash = "sha256-9+O/hi9UjnF4yPjR3tcUbxhg/ga0OpFGgVLvSW5FfbE=";
  }) { };
in
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
    openssl
    pciutils
    ripgrep
    meld
    nixfmt-rfc-style
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
      if [ "$TERM_PROGRAM" != "zed" ]; then
        eval "$(zellij setup --generate-auto-start bash)"
      fi
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

  programs.zed-editor = {
    enable = true;
    package = unstable_pkgs.zed-editor;
    extensions = [
      "make"
      "nix"
      "toml"
    ];
    userSettings = {
      "buffer_font_features" = {
        # Disable font ligatures
        "calt" = false;
      };
      "dap" = {
        "CodeLLDB" = {
          "binary" = "${pkgs.lldb}/bin/lldb-dap";
        };
      };
      "languages" = {
        "Nix" = {
          "language_servers" = [
            "nil"
            "!nixd"
          ];
        };
      };
      "load_direnv" = "shell_hook";
      "inlay_hints" = {
        "enabled" = true;
        "show_type_hints" = true;
      };
      "lsp" = {
        "nil" = {
          "binary" = {
            "path" = lib.getExe pkgs.nil;
          };
          "initialization_options" = {
            "formatting" = {
              "command" = [ "nixfmt" ];
            };
            "settings" = {
              "diagnostics" = {
                "ignored" = [ "unused_binding" ];
              };
            };
          };
        };
        "rust-analyzer" = {
          "binary" = {
            "path" = lib.getExe pkgs.rust-analyzer;
          };
          "initialization_options" = {
            "inlayHints" = {
              "maxLength" = null;
              "lifetimeElisionHints" = {
                "enable" = "skip_trivial";
                "useParameterNames" = true;
              };
              "closureReturnTypeHints" = {
                "enable" = "always";
              };
            };
          };
        };
      };
    };
  };

  dconf.settings = {
    "org/gnome/calculator" = {
      # Disable currency conversion refresh
      refresh-interval = 0;
    };
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
