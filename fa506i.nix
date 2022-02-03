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

    services.xserver = {
      displayManager = {
        gdm.enable = true;
        gdm.wayland = true;
        gdm.nvidiaWayland = true;
        sessionCommands = ''
          xrandr --setmonitor HDMI-A-0~1 2560/593x1440/334+1920+0 HDMI-A-0
          xrandr --setmonitor HDMI-A-0~2 880/204x1440/334+4480+0 none
        '';
      };
      videoDrivers = [ "modeset" "nvidia" ];

      desktopManager = {
        mate.enable = lib.mkForce false;
        gnome.enable = false;
        lxqt.enable = true;
      };

      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        config = ''
          --
          -- Configuration file for XMonad + MATE
          --
          --  Usage:
          --      * Copy this file to ~/.xmonad/
          --      * Run:    $ xmonad --recompile
          --      * Launch: $ xmonad --replace
          --      [Optional] Create an autostart to command with "xmonad --replace"
          --
          --  Author: Arturo Fernandez <arturo at bsnux dot com>
          --  Inspired by:
          --      Spencer Janssen <spencerjanssen@gmail.com>
          --      rfc <reuben.fletchercostin@gmail.com>
          --  License: BSD
          --
          import XMonad
          import XMonad.Config.Desktop
          import XMonad.Util.Run (safeSpawn)
          import qualified Data.Map as M
          import System.Environment (getEnvironment)
          import XMonad.Util.EZConfig
          import XMonad.Hooks.SetWMName
          import XMonad.Layout.LayoutScreens
          import XMonad.Layout.TwoPane
          
          mateConfig = desktopConfig
              { terminal    = "alacritty"
              , keys        = mateKeys <+> keys desktopConfig
              -- , startupHook = setWMName "LG3D"
              }
          
          mateKeys (XConfig {modMask = modm}) = M.fromList $
              [ ((modm, xK_p), mateRun)
              , ((modm .|. shiftMask, xK_q), spawn "mate-session-save --kill") ]
          
          mateRun :: X ()
          mateRun = withDisplay $ \dpy -> do
              rw <- asks theRoot
              mate_panel <- getAtom "_MATE_PANEL_ACTION"
              panel_run   <- getAtom "_MATE_PANEL_ACTION_RUN_DIALOG"
          
              io $ allocaXEvent $ \e -> do
                  setEventType e clientMessage
                  setClientMessageEvent e rw mate_panel 32 panel_run 0
                  sendEvent dpy rw False structureNotifyMask e
                  sync dpy False
          
          main = do
              xmonad $ mateConfig
                          { modMask = mod4Mask
                           , borderWidth = 4
                           , focusedBorderColor = "#7FBC71"
                          } `additionalKeysP` myKeys
          
          myKeys = [  (("M4-f"), spawn "firefox")
                     ,(("M4-a"), spawn "emacs")
                     -- ,("M4--", layoutSplitScreen 2 (TwoPane 0.74418604651 0.25581395349))
                     -- ,("M4-=", rescreen)
                     -- ,(("M4--"), spawn "xrandr -s 1280x800")
                     -- ,(("M4-="), spawn "xrandr -s 1920x1080")
                     ,(("M4-z"), kill)
                   ]
        '';
      };
    };

    system.stateVersion = "21.11";
    networking.hostName = "haemin-fa506i-nixos";
  };

}
