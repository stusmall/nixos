{ config, pkgs, ... }:



{
  home.username = "stusmall";
  home.homeDirectory = "/home/stusmall";

  home.stateVersion = "22.11";

  nixpkgs.config.allowUnfree = true;

  home.packages = [
    pkgs.alacritty
    pkgs.dig
    pkgs.docker
    pkgs.firefox
    pkgs.gnomeExtensions.dash-to-dock
    pkgs.gnupg
    pkgs.htop
    pkgs.jetbrains.clion
    pkgs.jetbrains.pycharm-professional
    pkgs.jq
    pkgs.kubectl
    pkgs.opensnitch-ui
    pkgs.openssl
    pkgs.pciutils
    pkgs.ripgrep
    pkgs.meld
    pkgs.nmap
    pkgs.signal-desktop
    pkgs.spotify
    pkgs.tokei
    pkgs.tree
    pkgs.usbutils
    pkgs.vscode
    pkgs.wireshark
    pkgs.whois
    pkgs.zellij
  ];

  home.sessionVariables = {
  };

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
        editor = "vim";
        compression = 9;
      };
      pull = {
        rebase = true;
      };
    };
  };

  programs.vim = {
    enable = true;
    defaultEditor = true;
    extraConfig = ''
set number
set nobackup nowritebackup noswapfile
'';
  };
  programs.zellij.settings = {
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
      enabled-extensions = ["appindicatorsupport@rgcjonas.gmail.com" "dash-to-dock@micxgx.gmail.com"];
      favorite-apps = ["Alacritty.desktop" "firefox.desktop" "clion.desktop" "pycharm-professional.desktop"];
    };
    "org/gnome/shell/extensions/dash-to-dock" = {
      apply-custom-theme = true;
    };
  };

  # Set start up applications
  # shitty version of this https://github.com/nix-community/home-manager/issues/3447#issuecomment-1328294558
   home.file.".config/autostart/opensnitch_ui.desktop".source = (pkgs.opensnitch-ui + "/share/applications/opensnitch_ui.desktop");

}

