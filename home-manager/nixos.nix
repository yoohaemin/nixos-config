{ config, pkgs, ... }:
{
  imports = [
    ./uim.nix
    ./fonts.nix
  ];
  
  home.packages = with pkgs; [
    github-desktop
  ];
  home.homeDirectory = "/home/haemin";
}
