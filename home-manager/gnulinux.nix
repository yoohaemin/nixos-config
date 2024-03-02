{ config, pkgs, ... }:
{
  home.packages = [
    pkgs.amberol
    pkgs.elisa
    pkgs.rhythmbox
    pkgs.vlc
  ];

  home.sessionPath = [
    "$HOME/.local/bin"
  ];
}
