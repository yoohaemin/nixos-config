{ config, pkgs, ... }:
{

  home.packages = with pkgs; [
    htop
    gh
    youtube-dl
    bloop
    httpie
    ripgrep
    xclip
    jq
    jd
    gitAndTools.git-interactive-rebase-tool
    postgresql
    terraform
    minikube
    docker
    docker-compose
    docker-machine
    # docker-machine-hyperkit
    # docker-machine-xhyve
  ];

#  programs.gh = {
#    enable = true;
#    aliases = {
#      co = "pr checkout";
#      pv = "pr view";
#    };
#    editor = "vim";
#    gitProtocol = "ssh";
#  };

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
