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

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "haemin-mbp-nix";
  # networking.wireless.enable = true;
  networking.networkmanager.enable = true;
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
    firefox 
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

    # JVM & Scala related
    sbt
    scala
    # bloop
    coursier
    ammonite
    jetbrains.idea-community
    # jetbrains.jdk # For when running stuff that requires jfx
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
    pkgs.gnome3.gnome-terminal
    httpie
    insomnia
    mosh
    which
    bind
    patchelf

    xorg.xev
    xorg.xkbcomp

    dhall
    dhall.prelude
  ] ++ [
    unstable.apacheKafka
    unstable.zookeeper
    unstable.bloop
    unstable.d2coding
    # unstable.jdk12
    # unstable.openjdk
    # unstable.graalvm8
    # unstable.mx
    unstable.leiningen
    unstable.clojure
    unstable.hy
    unstable.postman
  ];

  disabledModules = [ "servers/apache-kafka/default.nix" ];

  nixpkgs.config = {
    packageOverrides = pkgs: rec {
      # unstable = import unstableTarball { config = config.nixpkgs.config; };

      apacheKafka = unstable.apacheKafka;
      zookeeper = unstable.zookeeper;
      sbt = pkgs.sbt.override { jre = unstable.openjdk11; };
    };

    pulseaudio = true; # amixer set Master 10% (+/-)
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
  programs.java.package = pkgs.jetbrains.jdk; # Compatible with javafx (Conduktor)
  # programs.xss-lock.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

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


  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    libinput.enable = true; # Enable touchpad support.
    libinput.naturalScrolling = true;
    
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

    xkbOptions = "ctrl:nocaps";
  };

  services.flatpak.enable = true;
  services.flatpak.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  i18n.inputMethod = {
    enabled = "uim";
  };

  programs.zsh.ohMyZsh = {
    enable = true;
    plugins = [ "git" "man" "vi-mode" ];
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

   source $ZSH/oh-my-zsh.sh
  '';
  programs.zsh.promptInit = "";

  powerManagement.enable = true;

  hardware.enableAllFirmware = true;
  hardware.bluetooth.enable = true;
  # hardware.opengl.driSupport32Bit = true;
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
