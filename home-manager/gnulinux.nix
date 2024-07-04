{ config, pkgs, ... }:
{
  home.packages = [ pkgs.docker ];

  home.sessionPath = [
    "$HOME/.local/bin"
  ];
}
