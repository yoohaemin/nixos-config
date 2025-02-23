{ config, pkgs, ... }:
let
  unstable = import <unstable> {};
in
{

  home.file.".bloop/bloop.json".text = builtins.toJSON {
    javaOptions = [
      "-Xmx5G"
      "-XX:+UseParallelGC"
    ];
  };

  home.file.".sbt/1.0/plugins/plugins.sbt".text = ''
    addSbtPlugin("io.spray" % "sbt-revolver" % "0.10.0")
    addSbtPlugin("ch.epfl.scala" % "sbt-bloop" % "1.5.13")
    addDependencyTreePlugin
    addSbtPlugin("com.timushev.sbt" % "sbt-rewarn" % "0.1.3")
    addSbtPlugin("au.com.onegeek" % "sbt-dotenv" % "2.1.233")
    addSbtPlugin("ch.epfl.scala" % "sbt-missinglink" % "0.3.6")
    addSbtPlugin("com.timushev.sbt" % "sbt-updates" % "0.6.4")
  '';

  home.file.".sbt/1.0/global.sbt".text = ''
    scalacOptions ~= { options: Seq[String] =>
      options.filterNot(Set(
        "-Xfatal-warnings",
        "-Werror",
      ))
    }
  '';

  home.sessionVariables = {
    COURSIER_PROGRESS = "false"; # https://github.com/coursier/coursier/issues/1720
    JAVA_HOME = "$HOME/java";
  };

  # home.file.".local/bin/mill" = {
  #   executable = true;
  #   text = builtins.readFile (
  #     pkgs.fetchFromGitHub { 
  #       owner = "lefou";
  #       repo = "millw";
  #       rev = "8c59e4d62f80738870647d364b20a9731a3e2ee2";
  #       sha1 = "C4yE188eC3NaHGGzvaW7PVjxgvw=";
  #     } + "/millw"
  #   );
  # };

  home.packages = with pkgs; [
    # (unstable.coursier.override { jre = unstable.temurin-bin-21; })
    # (unstable.sbt.override { jre = unstable.temurin-bin-21; })
    # unstable.bloop
    # unstable.temurin-bin-21
    unstable.visualvm
  ];

  home.sessionPath = [
    "$HOME/.local/share/coursier/bin"
  ];
  
  programs.zsh.profileExtra = ''
    # >>> coursier install directory >>>
    export PATH="$PATH:/Users/haemin/Library/Application Support/Coursier/bin"
    # <<< coursier install directory <<<
  '';
}
