{ config, pkgs, ... }:
{

  home.packages = with pkgs; [
    vim
    htop
    youtube-dl
    httpie
    ripgrep
    xclip
    jq
    gitAndTools.git-interactive-rebase-tool
    postgresql
    terraform
    minikube
    docker
    docker-compose
    docker-machine
    scala-cli
    # nodejs
    # nodejs-16_x
    yarn
    nnn
    github-desktop
    fd
    vscodium
    wget
    google-cloud-sdk

    # Fonts
    d2coding
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
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
    html.enable = true;
    json.enable = true;
    manpages.enable = true;
  };

  news.display = "notify";
  nixpkgs.config = {
    allowUnfree = true;
  };

  programs.home-manager.enable = true;
  home.username = "haemin";
}
