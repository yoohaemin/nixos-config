{ config, pkgs, ... }:
{

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

}
