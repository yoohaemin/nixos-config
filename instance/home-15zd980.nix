{ config, lib, pkgs, ... }:
{
  imports = [ 
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>

    ./functionality/base.nix
    ./functionality/desktop.nix
    ./functionality/scala.nix
    ./functionality/dev-other.nix

    ./hardware/lg-15zd980.nix
  ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/30905406-b6a9-487a-84b4-5eb958bb5b7c";
      fsType = "f2fs";
    };

  fileSystems."/home/haemin/windows" =
    { device = "/dev/disk/by-uuid/3ACA1754CA170BAF";
      fsType = "ntfs";
      options = [ "rw" "uid=1000" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/EB26-FA9E";
      fsType = "vfat";
    };

  swapDevices = [ { device = "/dev/sdb6"; } { device = "/dev/sda2"; } ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
