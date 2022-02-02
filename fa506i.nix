{ config, lib, pkgs, modulesPath, ... }:
let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
in
{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  config = {

    boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" "aesni_intel" "cryptd" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelPackages = pkgs.linuxPackages_5_10;
    boot.kernelModules = [ "kvm-amd" ];

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

    hardware = {
      enableAllFirmware = true;
      cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      opengl = {
        enable = true;
        driSupport32Bit = true;
        extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
      };
      nvidia = {
        nvidiaPersistenced = true;
        nvidiaSettings = true;
        powerManagement.enable = true;
        powerManagement.finegrained = false;
        prime = {
          offload.enable = true;
          sync.enable = false;
          amdgpuBusId = "PCI:5:0:0";
          nvidiaBusId = "PCI:1:0:0";
        };
        modesetting.enable = true;
      };
    };

    # https://github.com/NixOS/nixpkgs/issues/108018 
    # services.xserver.videoDrivers = [ "nvidia" ];
    # services.xserver.videoDrivers = [ "amdgpu" ];
    boot.extraModulePackages = [ pkgs.linuxPackages.nvidia_x11 ];
    boot.blacklistedKernelModules = [ "nouveau" "nvidia_drm" "nvidia_modeset" ]; #"nvidia"
    environment.systemPackages = [ pkgs.linuxPackages.nvidia_x11 nvidia-offload ];


    # Option "PrimaryGPU" "Yes"
    #services.xserver.config = lib.mkAfter ''
    #  Driver "modesetting"
    #'';

    services.xserver = {
      displayManager = {
        gdm.enable = true;
        gdm.wayland = true;
        gdm.nvidiaWayland = true;
      };
      videoDrivers = [ "modeset" "nvidia" ];
    };

    system.stateVersion = "21.11";
    networking.hostName = "haemin-fa506i-nixos";
  };

}
