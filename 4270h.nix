# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, modulesPath, ... }:
let
  tuxedo = import (builtins.fetchTarball "https://github.com/liketechnik/tuxedo-nixos/archive/18340d8a914582d45c2823f3c244440bb3c8fdb5.tar.gz");
in
{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      tuxedo.module
      # ./sway.nix
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/306139de-ee33-4c3a-a17f-cb8c329eae9f";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-fb7eb37c-cc8e-4a0c-845a-8d32311cb4ab".device = "/dev/disk/by-uuid/fb7eb37c-cc8e-4a0c-845a-8d32311cb4ab";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/4746-9556";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/cd8961c9-a465-4a5d-b479-603ce050748f"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave"; # or "powersave" or "performance"
  services.auto-cpufreq.enable = true;
  services.thermald.enable = true;

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware.tuxedo-control-center.enable = true;
  # hardware.tuxedo-rs = {
  #   enable = true;
  #   tailor-gui.enable = true;
  # };

  boot.kernelPackages = pkgs.linuxPackages_zen;
  programs.nix-ld.enable = true;
  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-9514d6ec-6d04-4433-8952-f0c5fbd1ea96".device = "/dev/disk/by-uuid/9514d6ec-6d04-4433-8952-f0c5fbd1ea96";
  boot.initrd.luks.devices."luks-9514d6ec-6d04-4433-8952-f0c5fbd1ea96".keyFile = "/crypto_keyfile.bin";

  networking.hostName = "nixos-tfx4270h"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable network manager applet
  programs.nm-applet.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  hardware.pulseaudio = {
    package = pkgs.pulseaudioFull;
  };
  hardware.bluetooth.settings = {
  	General = {
  		Experimental = true;
  	};
  };
  services.blueman.enable = true;


  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ja_JP.UTF-8";
    LC_IDENTIFICATION = "ja_JP.UTF-8";
    LC_MEASUREMENT = "ja_JP.UTF-8";
    LC_MONETARY = "ja_JP.UTF-8";
    LC_NAME = "ja_JP.UTF-8";
    LC_NUMERIC = "ja_JP.UTF-8";
    LC_PAPER = "ja_JP.UTF-8";
    LC_TELEPHONE = "ja_JP.UTF-8";
    LC_TIME = "ja_JP.UTF-8";
  };

  i18n.inputMethod.enabled = "uim";

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    # desktopManager.gnome.enable = true;
    # displayManager.gdm.enable = true;
  };

  # Enable the MATE Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.mate.enable = true;
  services.xserver.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
  };

  # services.xserver.desktopManager.cinnamon.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "kr";
    xkbVariant = "kr104";
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  programs.adb.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.haemin = {
    isNormalUser = true;
    description = "Haemin Yoo";
    extraGroups = [ "networkmanager" "wheel" "docker" "adbusers" ];
    packages = with pkgs; [
      firefox
    #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    vim
    wget

    devmem2
    msr-tools
    linuxKernel.packages.linux_zen.turbostat
    pciutils

    # Gnome
    # gnomeExtensions.appindicator
    # gnomeExtensions.wireless-hid
    # gnomeExtensions.wifi-qrcode
    # gnomeExtensions.webfeed
    # gnomeExtensions.weather-or-not
    # gnomeExtensions.weather
    # gnomeExtensions.wayland-or-x11
    # gnomeExtensions.systemd-manager
    # gnome.adwaita-icon-theme
    # # gnomeExtensions.pop-shell
    # gnomeExtensions.gtk3-theme-switcher
    # yaru-theme
    # gnomeExtensions.appindicator
  ];

  # services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
  nix.settings.experimental-features = "nix-command flakes";

  virtualisation.waydroid.enable = true;

  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  virtualisation.docker.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
