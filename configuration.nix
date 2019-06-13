# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      ./dell-e6230.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "haemin-e6230";
  # networking.wireless.enable = true;
  networking.networkmanager.enable = true;

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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget 
    vim 
    emacs 
    sbt 
    tmux 
    scala 
    bloop
    coursier
    ammonite
    curl 
    zsh 
    git 
    firefox 
    thunderbird 
    pkgs.jetbrains.idea-community
    pkgs.gnome3.gnome-terminal
    # postman
    insomnia
    chromium
    mosh
    which
    networkmanager
    rustc
    cargo
    # vscodium
    nodejs
    docker
    docker-compose
    ngrok
    arandr
    ripgrep
    xss-lock
    i3lock

    adoptopenjdk-bin
    vscodium
    # jdk11
  ];

  fonts.fonts = [ 
    pkgs.google-fonts 
    pkgs.google-fonts 
  ];
  
  environment.variables = {
    TERMINAL = [ "gnome-terminal" ];
    OH_MY_ZSH = [ "${pkgs.oh-my-zsh}/share/oh-my-zsh" ];
  };
  
  programs.xss-lock.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

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


  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    libinput.enable = true; # Enable touchpad support.
    
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

    # https://github.com/wernight/docker-ngrok
    function docker-ngrok() {
      docker run --rm -it --link "$1":http wernight/ngrok ngrok http http:5001
    }

    source $ZSH/oh-my-zsh.sh
  '';
  programs.zsh.promptInit = "";

  powerManagement.enable = true;

  hardware.enableAllFirmware = true;
  hardware.bluetooth.enable = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    zeroconf.discovery.enable = true;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
    package = pkgs.pulseaudioFull;
  };
  nixpkgs.config.pulseaudio = true;

  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.haemin = {
    isNormalUser = true;
    home = "/home/haemin";
    description = "Haemin Yoo";
    shell = pkgs.zsh;
    extraGroups = [ 
      "wheel"             # Enable ‘sudo’ for the user.
      "networkmanager" 
      "video"             # Brightness Control
    ];
  };
  nixpkgs.config.allowUnfree = true;

  security.sudo.extraConfig = ''
    %wheel      ALL=(ALL:ALL) NOPASSWD: ALL
  '';

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03";

}
