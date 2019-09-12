{ config, pkgs, ... }:
{
  system.stateVersion = "19.03";
  environment.systemPackages = with pkgs; [
    wget
    curl
    httpie
    htop
    openssl
    bc
    tmux
    git
  ];
  nixpkgs.config.allowUnfree = true;
  programs.vim.defaultEditor = true;
  i18n.defaultLocale = "en_US.UTF-8";

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
