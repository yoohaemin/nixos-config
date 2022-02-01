{ config, pkgs, ... }:
# let
#   unstable = import <unstable>;
# in
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
    docker-machine-hyperkit
    docker-machine-xhyve
  ];

  programs.alacritty = {
    enable = true;
    settings = {
      env = {
        TERM = "xterm-256color";
      };
      window = {
        dimensions = {
          columns = 128;
          lines = 32;
        };
        padding = {
          x = 0;
          y = 0;
        };
        dynamic_padding = false;
        decorations = "full";
        startup_mode = "Windowed";
        title = "Terminal";
        dynamic_title = true;
      };
      scrolling = {
        history = 100000;
      };
      font = {
        normal.family = "D2Coding";
        size = 17.0;
      };
      colors = {
        # Pencil - Light
        # https://github.com/eendroroy/alacritty-theme/blob/ade1c9114cf37d0239c3499b74c8196cf1e6aee4/themes/pencil_light.yaml
        primary = {
          background = "0xf1f1f1";
          foreground = "0x424242";
        };
        # cursor = { # Cursors to neon green
        #   text   = "0xFFFFFF";
        #   cursor = "0x39FF14";
        # };
        normal = {
          black   = "0x212121";
          red     = "0xc30771";
          green   = "0x10a778";
          yellow  = "0xa89c14";
          blue    = "0x008ec4";
          magenta = "0x523c79";
          cyan    = "0x20a5ba";
          white   = "0xe0e0e0";
        };
        bright = {
          black   = "0x212121";
          red     = "0xfb007a";
          green   = "0x5fd7af";
          yellow  = "0xf3e430";
          blue    = "0x20bbfc";
          magenta = "0x6855de";
          cyan    = "0x4fb8cc";
          white   = "0xf1f1f1";
        };
      };
      mouse = {
        hide_when_typing = true;
        #url = {
        #  launcher = "open";
        #  modifiers = "None";
        #};
      };
      selection = {
        semantic_escape_chars = ",│`|:\"' ()[]{}<>";
        save_to_clipboard = true;
      };
      dynamic_title = true;
      cursor = {
        style = {
          shape = "Block";
          blinking = "Off";
        };
        unfocused_hollow = true;
        #vi_mode_style = {
        #  shape = "Block";
        #  blinking = "Off";
        #};
      };
      live_config_reload = true;
      alt_send_esc = true;
      key_bindings = [
        { key = "F"; mods = "Alt"; chars = "\\x1bf"; }
        { key = "B"; mods = "Alt"; chars = "\\x1bb"; }
      ];
    };
  };

  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [
      epkgs.nix-mode
      epkgs.magit
    ];
  };

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
    userEmail = "haemin@smartpay.co";
#    signing = {
#      key = "";
#      signByDefault = true;
#    };
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

  news.display = "silent"; #notify
  nixpkgs.config = {
    allowUnfree = true;
  };

  programs.zsh = {
    enable = true;
    autocd = true;
    enableAutosuggestions = false;
    history.extended = true;
    history.save = 500000;
    history.size = 500000;

    profileExtra = ''
      export PATH="$PATH:/Users/haemin/.nix-profile/bin:/Users/haemin/Library/Application Support/Coursier/bin:/Users/haemin/google-cloud-sdk/bin/:/Users/haemin/sbt/bin/"
      export GOOGLE_APPLICATION_CREDENTIALS="/Users/haemin/work/smartpayments/smartpay-dev-308107-723c6c83e689.json"
    '';

    dirHashes = {
      interview = "$HOME/work/interviews";
      smartpay  = "$HOME/work/smartpayments";
      electrum  = "$HOME/work/electrum";
      infra     = "$HOME/work/infra";
    };

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

#  home.activation.linkMyStuff = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
#    ln -sf ${config.home.homeDirectory}/.config/nixpkgs/.spacemacs ${config.home.homeDirectory}/.spacemacs
#  '';

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

  home.file.".bloop/bloop.json".text = builtins.toJSON {
    javaOptions = [
      "-Xmx5G"
      "-XX:+UseParallelGC"
    ];
  };

  home.file.".sbt/1.0/plugins/plugins.sbt".text = ''
    addSbtPlugin("io.spray" % "sbt-revolver" % "0.9.1")
    addSbtPlugin("ch.epfl.scala" % "sbt-bloop" % "1.4.12")
    addDependencyTreePlugin
    addSbtPlugin("com.timushev.sbt" % "sbt-rewarn" % "0.1.3")
    addSbtPlugin("au.com.onegeek" % "sbt-dotenv" % "2.1.233")
    addSbtPlugin("ch.epfl.scala" % "sbt-missinglink" % "0.3.3")
  '';

  home.file.".sbt/1.0/global.sbt".text = ''
    scalacOptions ~= { options: Seq[String] =>
      options.filterNot(Set(
        "-Xfatal-warnings",
        "-Werror",
      ))
}

  '';

  home.file."Library/KeyBindings/DefaultKeyBinding.dict".text = ''
    { "~a" = (); "~b" = (); "~c" = (); "~d" = (); "~e" = (); "~f" = (); "~g" = (); "~h" = (); "~i" = (); "~j" = (); "~k" = (); "~l" = (); "~m" = (); "~n" = (); "~o" = (); "~p" = (); "~q" = (); "~r" = (); "~s" = (); "~t" = (); "~u" = (); "~v" = (); "~w" = (); "~x" = (); "~y" = (); "~z" = (); }
  '';

  programs.home-manager.enable = true;
  home.username = "haemin";
  home.homeDirectory = "/Users/haemin";
}
