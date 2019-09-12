# desktop.nix

{ config, pkgs, ... }:
{
  networking = {
    networkmanager.enable = true;
    extraHosts = ''
      209.51.188.89 elpa.gnu.org
    '';
  };

  i18n = {
    consoleFont = "iso02-12x22";
    consoleKeyMap = "kr";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Asia/Seoul";

  programs.light.enable = true;
}
