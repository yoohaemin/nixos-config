{ config, pkgs, ... }:

let
  # unstableTarball = fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz;
  baseConfig = { 
    allowUnfree = true; 
    packageOverrides = upkgs: {
      apacheKafka = upkgs.apacheKafka.override { jre = pkgs.openjdk11; };
      zookeeper = upkgs.zookeeper.override { jre = pkgs.openjdk11; };
    };
  };

  # $ sudo nix-channel --add https://nixos.org/channels/nixos-unstable unstable
  # $ sudo nix-channel --update unstable
  unstable = import <unstable> { config = baseConfig; };
in
{
  imports =
    [
      <nixos-hardware/apple/macbook-pro/11-5>
      ./macbook.nix
    ];

  system.stateVersion = "19.03";

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "haemin-mbp-nix";
  networking.enableIPv6 = false;
  # networking.wireless.enable = true;
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
  time.timeZone = "Asia/Seoul";

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

    # JVM & Scala related
    scala
    # bloop
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

    python27Packages.demjson

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
  ] ++ [
    unstable.bloop
    unstable.leiningen
    unstable.clojure
    unstable.hy
    # unstable.postman
    unstable.dhall
    # unstable.dhall.prelude

    unstable.xfce.terminal
    unstable.alacritty

    unstable.mongodb-compass

    unstable.jetbrains.idea-community
    unstable.jetbrains.jdk
  ];

  disabledModules = [ "servers/apache-kafka/default.nix" ];

  nixpkgs.config = {
    packageOverrides = pkgs: rec {
      # apacheKafka = unstable.apacheKafka.override { jre = unstable.jdk11; };
      # zookeeper = unstable.zookeeper.override { jre = unstable.jdk11; };
      sbt = unstable.sbt.override { jre = unstable.adoptopenjdk-openj9-bin-11; };
      # python = pkgs.python37;
    };

    pulseaudio = true; # amixer set Master 10% (+/-)
    chromium = {
      enablePepperFlash = false;
    };
    firefox = {
      enableAdobeFlash = false;
    };
    allowUnfree = true;
  };

  services = {
    apache-kafka = {
      enable = true;
      extraProperties = ''
        transaction.state.log.replication.factor=1
        offsets.topic.replication.factor=1
      '';
    };

    zookeeper.enable = true;
  };

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [ 
      anonymousPro
      corefonts
      dejavu_fonts
      noto-fonts
      freefont_ttf
      google-fonts
      inconsolata
      liberation_ttf
      powerline-fonts
      source-code-pro
      terminus_font
      ttf_bitstream_vera
      ubuntu_font_family
    ] ++ [
      unstable.d2coding
    ];
  };
  
  environment.variables = {
    TERMINAL = [ "gnome-terminal" ];
    OH_MY_ZSH = [ "${pkgs.oh-my-zsh}/share/oh-my-zsh" ];
  };

  programs.vim.defaultEditor = true;
  programs.java.enable = true;
  programs.java.package = unstable.graalvm8; # unstable.jetbrains.jdk is Compatible with javafx (Conduktor)
  # programs.xss-lock.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = false;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  sound.mediaKeys = {
    enable = true;
    volumeStep = "5%";
  };
  hardware.brightnessctl.enable = true;
  services.illum.enable = true;

  services.autorandr.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "kr";
    xkbVariant = "kr104";
    libinput.enable = true; # Enable touchpad support.
    libinput.naturalScrolling = false;
    
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = haskellPackages: [
        haskellPackages.xmonad-contrib
        haskellPackages.xmonad-extras
        haskellPackages.xmonad
      ];
    };
    windowManager.default = "xmonad";
    desktopManager.xterm.enable = false;

    # setxkbmap -option 
    xkbOptions = "ctrl:nocaps"; # altwin:swap_alt_win
  };

  # services.flatpak.enable = false;
  # services.flatpak.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  i18n.inputMethod = {
    enabled = "uim";
  };

  programs.zsh.ohMyZsh = {
    enable = true;
    plugins = [ "git" "man" ];
    theme = "simple";
  };

  programs.zsh.enable = true;
  programs.zsh.interactiveShellInit = ''
    export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh/

    # Customize your oh-my-zsh options here
    ZSH_THEME="simple"
    plugins=(git docker)

    bindkey '\e[5~' history-beginning-search-backward
    bindkey '\e[6~' history-beginning-search-forward

    HISTFILESIZE=500000
    HISTSIZE=500000
    setopt SHARE_HISTORY
    setopt HIST_IGNORE_ALL_DUPS
    setopt HIST_IGNORE_DUPS
    setopt INC_APPEND_HISTORY
    autoload -U compinit && compinit
    unsetopt menu_complete
    setopt completealiases

    if [ -f ~/.aliases ]; then
      source ~/.aliases
    fi

    bindkey -e
    source $ZSH/oh-my-zsh.sh
  '';
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
