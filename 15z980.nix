{ config, lib, pkgs, modulesPath, ... }:
{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  config = {
    boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" "aesni_intel" "cryptd" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-intel" ];
    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.extraModulePackages = [ ];

    fileSystems."/" =
      { device = "/dev/disk/by-uuid/da2e9781-aaae-4b5f-92c0-06378a5639be";
        fsType = "ext4";
      };

    boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/03c74023-0287-4caa-a75b-24f267eefda9";

    fileSystems."/boot" =
      { device = "/dev/disk/by-uuid/62BB-5AC7";
        fsType = "vfat";
      };

    swapDevices = [ ];

    powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    system.stateVersion = "21.11";
    networking.hostName = "haemin-15z980-nixos";

    environment.systemPackages = with pkgs; [
      brightnessctl
    ];

    services.xserver.desktopManager.gnome.enable = true;
    services.xserver.desktopManager.gnome.flashback.enableMetacity = true;
  };
}
