{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    htop
    git
  ];


  home.username = "haemin";
  home.homeDirectory = "/home/haemin";
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;
}
