{ config, pkgs, ... }:
{
  imports = [
    ./uim.nix
    ./fonts.nix
  ];
  
  home.homeDirectory = "/home/haemin";
}
