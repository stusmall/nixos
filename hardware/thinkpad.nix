{
  config,
  lib,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./base.nix
    ../nixos-modules/fwupd.nix
    ../nixos-modules/steam.nix
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usb_storage"
    "sd_mod"
    "rtsx_pci_sdmmc"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "thinkpad";

  fileSystems."/" = {
    device = "/dev/mapper/luks-376e659a-7520-4bf3-8c7c-df30575f311e";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-376e659a-7520-4bf3-8c7c-df30575f311e".device =
    "/dev/disk/by-uuid/376e659a-7520-4bf3-8c7c-df30575f311e";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/FDD4-104E";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  services.xserver.videoDrivers = [
    # For offloading, `modesetting` is needed additionally,
    "modesetting"
    # Load nvidia driver for Xorg and Wayland
    "nvidia"
  ];

  hardware.nvidia = {
    open = true;

    prime = {
      offload.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = true;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = true;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = false;
  };
}
