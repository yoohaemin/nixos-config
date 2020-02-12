# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/hardware/network/broadcom-43xx.nix>
      <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.kernelParams = [ "ipv6.disable=1" "video=eDP:1680x1050@60" ];

  hardware.enableAllFirmware = true;

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/69ae37d9-7490-46b7-af81-2929a22bcc22";
      fsType = "f2fs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/67E3-17ED";
      fsType = "vfat";
    };

  swapDevices = [ { device = "/var/swapfile"; priority = 0; size = 16384; } ];

  nix.maxJobs = lib.mkDefault 8;
  powerManagement = {
    cpuFreqGovernor = lib.mkDefault "ondemand";

    # Fix wifi issues after resume: see wifi doesn't work after suspend after 16.04 upgrade @AskUbuntu
    # ~ lspci -knn | grep Net -A2
    # 04:00.0 Network controller [0280]: Broadcom Inc. and subsidiaries BCM43602 802.11ac Wireless LAN SoC [14e4:43ba] (rev 01)
    #         Subsystem: Apple Inc. Device [106b:0133]
    #         Kernel driver in use: brcmfmac
    resumeCommands = ''
      rmmod hid_apple && modprobe hid_apple
      rmmod brcmfmac && modprobe brcmfmac
    '';
  };

    # Some configuration for those annoying Apple keyboards.
  boot.extraModprobeConfig = ''
    # Function/media keys:
    #   0: Function keys only.
    #   1: Media keys by default.
    #   2: Function keys by default.
    options hid_apple fnmode=2
    # Fix tilde/backtick key.
    # options hid_apple iso_layout=0
    # Swap Alt key and Command key.
    options hid_apple swap_opt_cmd=1
  '';

  services.mbpfan = {
    enable = true;
    minFanSpeed = 2500;
    lowTemp = 50;
    highTemp = 53;
    maxTemp = 70;
    pollingInterval = 3;
    verbose = true;
  };

}