{ config, pkgs, ... }:

let
  baseConfig = { 
    allowUnfree = true; 
  };

  # unstableTarball = fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz;
  unstable = import <unstable> { config = baseConfig; };
  nixpkgs-unstable = import <nixpkgs-unstable> { config = baseConfig; };
in
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.enableIPv6 = true;
  networking.networkmanager.enable = true;
  networking.networkmanager.packages = [ 
    pkgs.networkmanager-l2tp
  ];
  environment.etc."ipsec.secrets".text = ''
    include ipsec.d/ipsec.nm-l2tp.secrets
  '';
  services.xl2tpd.enable = true;
  networking.extraHosts = ''
    209.51.188.89 elpa.gnu.org
  '';

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  environment.systemPackages = with pkgs; [
    # General stuffs
    vim 
    chromium
    wget 
    curl 
    emacs
    firefoxWrapper
    thunderbird 
    ngrok
    arandr
    ripgrep
    networkmanager
    i3lock
    i7z
    vlc
    htop
    xss-lock
    lm_sensors # `sensors` for system temperatures
    openssl
    okular
    nixops
    youtube-dl
    bc
    libreoffice
    keybase
    awscli
    gitAndTools.diff-so-fancy
    gitAndTools.git-fame
    file
    light
    xmobar
    acpi
    pciutils
    lshw
    inxi

    # JVM & Scala related
    scala
    bloop
    coursier
    ammonite
    visualvm

    # Other dev tools
    rustc
    cargo
    nodejs
    python3
    vscodium
    docker
    docker-compose
    tmux
    zsh
    git
    git-lfs
    pkgs.gnome3.gnome-terminal
    httpie
    insomnia
    mosh
    which
    bind
    traceroute
    patchelf
    stack
    cabal-install
    ghc
    yarn

    entr
    xorg.xev
    xorg.xkbcomp

    dmenu
    unzip
    maven
    bazel

    beam.interpreters.erlang
    beam.interpreters.elixir
    # beam.interpreters.lfe

    steam-run-native
    p7zip
    evince

    gnome3.networkmanagerapplet

    google-chrome
    sbt
    brightnessctl
  ] ++ [
    unstable.bloop
    unstable.leiningen
    unstable.clojure
    unstable.hy
    unstable.dhall
    # unstable.dhall.prelude

    unstable.xfce.terminal
    unstable.alacritty

    nixpkgs-unstable.jetbrains.idea-community
  ];

  nixpkgs.config = {
    packageOverrides = 
      pkgs: rec {
        sbt = pkgs.sbt.override { jre = nixpkgs-unstable.graalvm11-ce; };
      };

    pulseaudio = true; # amixer set Master 10% (+/-)
    allowUnfree = true;
  };

  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      anonymousPro
      corefonts
      d2coding
      dejavu_fonts
      dina-font
      fira-code
      fira-code-symbols
      freefont_ttf
      google-fonts
      inconsolata
      liberation_ttf
      mplus-outline-fonts
      nerdfonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      powerline-fonts
      proggyfonts
      source-code-pro
      terminus_font
      ttf_bitstream_vera
      ubuntu_font_family
    ];
  };
  
  environment.variables = {
    TERMINAL = [ "gnome-terminal" ];
    OH_MY_ZSH = [ "${pkgs.oh-my-zsh}/share/oh-my-zsh" ];
  };

  programs.vim.defaultEditor = true;
  programs.java.enable = true;
  programs.java.package = nixpkgs-unstable.graalvm11-ce; # unstable.jetbrains.jdk
  # programs.xss-lock.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = false;
  networking.firewall.enable = true;
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  services.printing.enable = true;
  sound.enable = true;
  sound.mediaKeys = {
    enable = true;
    volumeStep = "5%";
  };
  services.illum.enable = false;
  services.autorandr.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "kr";
    xkbVariant = "kr104";
    libinput.enable = true; # Enable touchpad support.
    libinput.touchpad.naturalScrolling = false;
    desktopManager.xterm.enable = false;
    desktopManager.mate.enable = true;

    # setxkbmap -option 
    xkbOptions = "ctrl:nocaps"; # altwin:swap_alt_win
  };

  #services.xserver = {
  #  enable = true;
  #  layout = "kr";
  #  xkbVariant = "kr104";
  #  libinput.enable = true; # Enable touchpad support.
  #  libinput.naturalScrolling = false;
  #  
  #  windowManager.xmonad = {
  #    enable = true;
  #    enableContribAndExtras = true;
  #    extraPackages = haskellPackages: [
  #      haskellPackages.xmonad-contrib
  #      haskellPackages.xmonad-extras
  #      haskellPackages.xmonad
  #    ];
  #  };
  #  windowManager.default = "xmonad";
  #  desktopManager.xterm.enable = false;
  #
  #  # setxkbmap -option 
  #  xkbOptions = "ctrl:nocaps"; # altwin:swap_alt_win
  #};

  # services.flatpak.enable = false;
  # services.flatpak.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  programs.zsh.promptInit = "";

  powerManagement.enable = true;

  hardware.enableAllFirmware = true;
  hardware.bluetooth.enable = true;
  # hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages = [ pkgs.vaapiIntel ];
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    zeroconf.discovery.enable = true;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
    package = pkgs.pulseaudioFull;
  };

  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = true;

  users.users.haemin = {
    isNormalUser = true;
    home = "/home/haemin";
    description = "Haemin Yoo";
    shell = pkgs.zsh;
    extraGroups = [ 
      "wheel"             # Enable ‘sudo’ for the user.
      "networkmanager" 
      "video"             # Brightness Control
      "docker"
    ];
  };

  security.sudo.extraConfig = ''
    %wheel      ALL=(ALL:ALL) NOPASSWD: ALL
  '';
}
