{ config, pkgs, ... }:
{

  home.file."Library/KeyBindings/DefaultKeyBinding.dict".text = ''
    { "~a" = (); "~b" = (); "~c" = (); "~d" = (); "~e" = (); "~f" = (); "~g" = (); "~h" = (); "~i" = (); "~j" = (); "~k" = (); "~l" = (); "~m" = (); "~n" = (); "~o" = (); "~p" = (); "~q" = (); "~r" = (); "~s" = (); "~t" = (); "~u" = (); "~v" = (); "~w" = (); "~x" = (); "~y" = (); "~z" = (); }
  '';

  home.homeDirectory = "/Users/haemin";

  # home-manager.useGlobalPkgs = true;
  # home-manager.useUserPackages = true;

  programs.zsh = {
    profileExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';
  };
}
