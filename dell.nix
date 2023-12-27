{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ./base.nix
    ./modules/encrypted-dns.nix
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "dell-3551";

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/6b3805a2-8df8-4407-aacc-dd32784075a8";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-1b1be12b-e63c-4077-aae8-f90352cd9d68".device = "/dev/disk/by-uuid/1b1be12b-e63c-4077-aae8-f90352cd9d68";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/950B-E02A";
      fsType = "vfat";
    };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
