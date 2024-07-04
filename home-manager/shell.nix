{ config, pkgs, ... }:
{

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.tmux = {
    enable = true;
    escapeTime = 0;
    keyMode = "vi";
    terminal = "xterm-256color";
    historyLimit = 100000;
    prefix = "`";
  };

  programs.zsh = {
    enable = true;
    autocd = true;
    enableAutosuggestions = false;
    history.extended = true;
    history.save = 500000;
    history.size = 500000;

    shellAliases = {
        djdj = "bloop projects | xargs -L1 bloop compile";
        dkdk = "bloop compile root -w --cascade";
        slsl = "bloop projects | xargs -L1 bloop test";
        gpa  = "git pull --all";
    };

    oh-my-zsh = {
      enable = true;
      theme = "simple";
      plugins = ["git" "docker" ];
    };
  };
}
