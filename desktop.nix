{ config, lib, modulesPath, pkgs, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      ./base.nix
      ./modules/ollama.nix
      ./modules/sshd.nix
      ./modules/steam.nix
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
      device = "/dev/disk/by-uuid/4990cefe-a612-4cce-a5bc-5c1553c811a2";
      fsType = "ext4";
      options = [
        "noatime"
      ];
    };

  boot.initrd.luks.devices."luks-50826637-979d-4a6f-8406-9688a70629b6".device = "/dev/disk/by-uuid/50826637-979d-4a6f-8406-9688a70629b6";

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/33AF-0758";
      fsType = "vfat";
    };

  swapDevices = [ ];
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
