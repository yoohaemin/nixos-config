{ config, pkgs, ... }:
let
  gcloud = pkgs.google-cloud-sdk.withExtraComponents([
              pkgs.google-cloud-sdk.components.pubsub-emulator
              pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin
           ]);
  unstable = import <unstable> {};
  my-python-packages = ps: with ps; [
    pandas
    requests
    pip
    # other python packages
  ];
in
{
  home.packages = with pkgs; [
    vim
    htop
    youtube-dl
    # httpie
    ripgrep
    xclip
    jq
    gitAndTools.git-interactive-rebase-tool
    # unstable.postgresql
    terraform
    minikube
    scala-cli
    gcloud
    # nodejs
    nodejs
    yarn
    nnn
    fd
    vscodium
    wget
    unstable.talosctl
    unstable.kubectl
    unstable.clusterctl
    # unstable.wrangler
    # (unstable.python3.withPackages my-python-packages)
    # unstable.python3
    texlive.combined.scheme-full
    unstable.chromium # ungoogled-

    python3
    poetry
    # visualvm

    # Fonts
    # d2coding
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    nerdfonts
    # liberation_ttf
    # fira-code
    # fira-code-symbols
    # mplus-outline-fonts.githubRelease
    # dina-font
    # proggyfonts
  ];

  programs.gh = {
    enable = true;
    settings.aliases = {
      co = "pr checkout";
      pv = "pr view";
    };
    settings.editor = "vim";
    settings.git_protocol = "ssh";
  };

  programs.git = {
    enable = true;
    userName = "Haemin Yoo";
    ignores = [ ".bsp/" ".bloop/" ".metals/" "haemin.sbt" ];
    extraConfig = {
      pull = {
        ff = "only";
      };
      core = {
        editor ="vim";
      };
      sequence = {
        editor ="interactive-rebase-tool";
      };
      advice.detachedHead = false;
    };
  };

  manual = {
    # html.enable = true;
    # json.enable = true;
    manpages.enable = false;
  };

  news.display = "notify";
  nixpkgs.config = {
    allowUnfree = true;
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  programs.autojump.enable = true;

  programs.home-manager.enable = true;
  home.username = "haemin";
}
