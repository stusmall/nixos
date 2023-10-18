{ config, lib, pkgs, ... }:

{
  imports =
    [
      <home-manager/nixos>
      # This needs to link to the the absolute path and not a relative path.   We don't know which hardware config the bootstrap script picked so we need to use that symlink
      /etc/nixos/hardware-configuration.nix
      ./modules/antivirus.nix
      ./modules/dns.nix
      ./modules/opensnitch.nix
    ];


  # Use the newest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

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
  users.groups.wireshark = { };
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
    vim
  ];

  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    cheese
    gnome-calendar
    gnome-maps
    gnome-music
    gnome-terminal
    gnome-weather
    epiphany
    geary
    gnome-characters
    totem
    tali
    iagno
    hitori
    atomix
    yelp
  ]);



  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
