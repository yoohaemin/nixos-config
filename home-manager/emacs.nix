{ config, pkgs, ... }:
{

  programs.emacs = {
    enable = true;
  };

  home.sessionPath = [ "$HOME/.emacs.d/bin" ];
}
