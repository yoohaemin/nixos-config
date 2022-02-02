{ config, pkgs, ... }:
{

  imports = [
    ./alacritty.nix
    ./base.nix
    ./emacs.nix
    ./nixos.nix
    ./scala.nix
    ./shell.nix
  ];

  programs.git.userEmail = "haemin@zzz.pe.kr";
}
