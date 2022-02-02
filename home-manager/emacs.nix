{ config, pkgs, ... }:
{

  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [
      epkgs.nix-mode
      epkgs.magit
    ];
  };

  home.file.".emacs.d" = {
    # don't make the directory read only so that impure melpa can still happen
    # for now
    recursive = true;
    source = pkgs.fetchFromGitHub {
      owner = "syl20bnr";
      repo = "spacemacs";
      rev = "ca93e28a9c1e99d3611ccda30a1263e61f0141ad";
      sha256 = "04m8z7gajnafrvkbwgiasijs5cli3h5k31xrj6nb52i0qzsglmr7";
    };
  };

}
