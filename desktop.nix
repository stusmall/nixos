{ config, lib, modulesPath, pkgs, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      ./base.nix
      ./modules/steam.nix
      ./modules/work.nix
    ];

  # Use the newest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "desktop";

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/af1c6485-22a5-49d6-9aa4-fdd51c06e75d";
      fsType = "ext4";
      options = [
        "commit=300,noatime"
      ];
    };

  boot.initrd.luks.devices."luks-1f5300da-10e9-4730-b25b-9eed41ac33d3".device = "/dev/disk/by-uuid/1f5300da-10e9-4730-b25b-9eed41ac33d3";

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/DC37-A158";
      fsType = "vfat";
    };

  swapDevices = [ ];
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
