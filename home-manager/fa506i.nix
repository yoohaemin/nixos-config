{ config, pkgs, ... }:
{

  imports = [
    ./base.nix
    ./emacs.nix
    ./nixos.nix
    ./obs.nix
    ./scala.nix
    ./shell.nix
    ./xmonad.nix
  ];

  #shellAliases = {
  #  whichgpu = "glxinfo | grep vendor";
  #  nvidiaon =
  #        "export __NV_PRIME_RENDER_OFFLOAD=1; export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0; export __GLX_VENDOR_LIBRARY_NAME=nvidia; export __VK_LAYER_NV_optimus=NVIDIA_only; glxinfo | grep vendor; echo OK!";
  #};

  programs.git.userEmail = "haemin@zzz.pe.kr";
  home.stateVersion = "22.05";
}
