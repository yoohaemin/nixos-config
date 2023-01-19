{ config, pkgs, ... }:
{
  home.file.".xmonad/xmonad.hs".source =
    config.lib.file.mkOutOfStoreSymlink config/xmonad.hs; # "${config.home.homeDirectory}/projects/nixos-config/home-manager/config/xmonad.hs";
  
  home.packages = with pkgs; [
    stack
  ];
}
