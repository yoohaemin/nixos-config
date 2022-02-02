# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" "aesni_intel" "cryptd" "amdgpu" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/5e309bb0-b87d-4650-ac8e-1d14ccc0bbfa";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/7a9790c9-b79b-41ee-9435-d1d771acd941";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/B0A0-CE85";
      fsType = "vfat";
    };

  swapDevices = [ ];

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # NixOS doesn't support dual-gpu hardware yet, and I also don't care about the eGPU that much too
  # Using internal amdgpu for now
  # https://github.com/NixOS/nixpkgs/issues/108018 
  # services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.videoDrivers = [ "amdgpu" ];

  system.stateVersion = "21.11";
  networking.hostName = "haemin-fa506i-nixos";
}
