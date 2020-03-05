{ pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    # system monitors
    htop
    powertop

    # software dev tools
    ag
    nixfmt

    # chat clients
    discord
    tdesktop

    # chrome is necessary for granblue
    qutebrowser

    # tunes
    cmus

    # graphical stuff
    xss-lock
    feh
    light

    bitwarden

    texlive.combined.scheme-medium
  ];

  programs.zsh = {
    enable = true;
    defaultKeymap = "emacs";
    localVariables = {
      PROMPT = "%F{green}vec%f@%F{magenta}s-s%f %F{blue}%B%~%b%f %# ";
    };
  };

  programs.git = {
    enable = true;
    userEmail = "relativistic.policeman@gmail.com";
    userName = "Ash";
  };

  programs.taskwarrior = { enable = true; };

  programs.beets = {
    enable = true;
    settings = {
      directory = "~/music";
      plugins = "fromfilename";
    };
  };

  programs.neovim = {
    enable = true;
    extraConfig = builtins.readFile ./config.vim;

    plugins = with pkgs.vimPlugins; [
      # generally useful stuff
      vim-startify
      vim-sensible

      # it's like a real IDE!
      vim-airline
      ale
      ctrlp

      # language support
      vim-nix
      rust-vim

      # fast text editing
      vim-surround

      # Plugins
      iceberg-vim

    ];
  };

  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = "0.85";
      font_family = "Iosevka Term";
      font_size = 13;
    };
  };

  programs.rofi = {
    enable = true;
    theme = ./interstellar.rasi;
  };

  services.compton = {
    enable = true;
    backend = "glx";
    shadow = true;
    fade = true;
    fadeDelta = 3;
    vSync = "true";
  };

  services.dunst = {
    enable = true;
    settings = rec {
      global = {
        markup = "none";
        format = "<big><b>%s</b></big>\\n%b";
        sort = false;
        alignment = "left";
        bounce_freq = 0;
        word_wrap = true;
        ignore_newline = false;
        geometry = "450x100-15+49";
        transparency = 10;
        separator_height = 2;
        padding = 12;
        horizontal_padding = 20;
        line_height = 3;
        separator_color = "frame";
        frame_width = 2;
        frame_color = "#EC5F67";

        show_indicators = false;

        icon_position = "left";
        max_icon_size = 60;
      };

      urgency_normal = {
        foreground = "#CDD3DE";
        background = "#101010";
        timeout = 6;
      };
      urgency_low = urgency_normal;
      urgency_critical = urgency_normal;
    };
  };

  services.flameshot = { enable = true; };

  services.polybar = {
    enable = true;
    package = pkgs.polybar.override { i3GapsSupport = true; };

    # Extra packages necessary for the cmus script.
    script = "PATH=$PATH:${pkgs.cmus}/bin:${pkgs.busybox}/bin polybar bar &";
    config = import ./polybar.nix;
  };

  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = "Mod4";
      keybindings = let modifier = "Mod4";
      in lib.mkOptionDefault {
        "${modifier}+d" = "exec --no-startup-id rofi -show drun";

        XF86AudioRaiseVolume =
          "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +10%";
        XF86AudioLowerVolume =
          "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -10%";
        XF86AudioMute =
          "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle";

        XF86MonBrightnessUp = "exec --no-startup-id light -A 10";
        XF86MonBrightnessDown = "exec --no-startup-id light -U 10";

        "Shift+Print" = "exec flameshot gui";
        Print = "exec flameshot full -p $HOME/Documents/screenshots";

        "${modifier}+minus" = "scratchpad show";
        "${modifier}+Shift+minus" = "move scratchpad";
      };

      bars = [ ];

      startup = [
        {
          command =
            "xss-lock --transfer-sleep-lock -- i3lock -i ~/wallpapers/anime/sakuya-knives.png";
          notification = false;
        }
        {
          command = "feh --bg-scale ~/wallpapers/anime/alice-marisa-sakuya.jpg";
          always = true;
          notification = false;
        }
      ];

      gaps = {
        inner = 8;
        outer = 0;
      };
      window = {
        commands = [
          # Apparently you have to disable titlebars for i3-gaps. Dunno why.
          {
            command = "border pixel 1";
            criteria = { class = ".*"; };
          }
        ];
      };
    };
  };
}
