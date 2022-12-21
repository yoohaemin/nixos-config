{ config, pkgs, ... }:
{

  imports = [
    ./alacritty.nix
    ./base.nix
    ./emacs.nix
    ./macos.nix
    ./scala.nix
    ./shell.nix
  ];

  programs.git.userEmail = "haemin@smartpay.co";
  home.stateVersion = "22.05";
}
