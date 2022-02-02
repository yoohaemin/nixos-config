{ config, pkgs, ... }:
{
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
}
