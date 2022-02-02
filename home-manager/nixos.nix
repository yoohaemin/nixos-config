{ config, pkgs, ... }:
{
  imports = [
    ./uim.nix
  ];
  
  home.homeDirectory = "/home/haemin";
}
