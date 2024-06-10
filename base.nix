{ pkgs, ... }:

{
  imports =
    [
      <home-manager/nixos>
      ./modules/antivirus.nix
      ./modules/docker.nix
      ./modules/gnome.nix
      ./modules/jetbrains.nix
      ./modules/opensnitch.nix
      ./modules/rust.nix
      ./modules/signal.nix
      ./modules/wireshark.nix
    ];

  # Set a limit on the number of generations to include in boot
  boot.loader.systemd-boot.configurationLimit = 20;

  # clean tmp directory on boot.  Otherwise this fills up overtime and causes issues
  boot.tmp.cleanOnBoot = true;


  # Enable networking
  networking.networkmanager.enable = true;


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

  # Needed for smartcard management and the yubikey rust crate
  services.pcscd.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
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

  # Leave bluetooth off on boot, the user can enable if needed
  hardware.bluetooth.powerOnBoot = false;

  users.users.stusmall = {
    isNormalUser = true;
    description = "Stuart Small";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Make nixos-rebuild invoke home-manager
  home-manager.users.stusmall = import ./home.nix;


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable auto-upgrades.
  system.autoUpgrade = {
    enable = true;
    # Run daily
    dates = "daily";
    # Build the new config and make it the default, but don't switch yet.  This will be picked up on reboot.  This helps
    # prevent issues with OpenSnitch configs not well matching the state of the system.
    operation = "boot";
  };

  # Enable udev settings for yubikey personalization
  services.udev.packages = [ pkgs.yubikey-personalization ];


  environment.systemPackages = with pkgs; [
    helix
    home-manager
  ];


  # Set up auto-cpufreq for better power management.
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "never";
    };
    charger = {
      governor = "performance";
      turbo = "auto";
    };
  };
  # This is the service that lets you pick power profiles in the gnome UI.  It conflicts with auto-cpufreq
  services.power-profiles-daemon.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}


