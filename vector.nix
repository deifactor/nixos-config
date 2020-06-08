{ pkgs, lib, ... }:

let
  customVimPlugins = with pkgs.vimUtils; {
    pgmnt-vim = buildVimPlugin {
      name = "pgmnt-vim";
      src = pkgs.fetchFromGitHub {
        owner = "cocopon";
        repo = "pgmnt.vim";
        rev = "89b8f0885a0fd7189f2f46b13e03d9e254793538";
        sha256 = "09pqhrpz0xx3qy9jxw3sp1sg0471p41gd1yrz0pmhnxr8qgwa77p";
      };
    };
    inspecthi-vim = buildVimPlugin {
      name = "inspecthi-vim";
      src = pkgs.fetchFromGitHub {
        owner = "cocopon";
        repo = "inspecthi.vim";
        rev = "b8a794e808b35d852c51bcdc67c5307dda943517";
        sha256 = "0rnwjqysjjbmrcqinjf0d6lbsmb6f31avfx4f0hr6qw3a1ax67yp";
      };
    };
    colorswatch-vim = buildVimPlugin {
      name = "colorswatch-vim";
      src = pkgs.fetchFromGitHub {
        owner = "cocopon";
        repo = "colorswatch.vim";
        rev = "2e3f847fc0e493de8b119d3c8560e47ceeff595c";
        sha256 = "18sllamrgdckfaxmy9awh49xm7nvi8ww4asgj36gwdchch2bn112";
      };
    };
  };
in
rec {
  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    # system monitors
    htop
    powertop

    # software dev tools
    ag
    nixfmt
    direnv
    gdb
    fzf

    # chat clients
    discord
    tdesktop
    weechat

    (import ./nixpkgs-qutebrowser/default.nix {})

    # tunes
    cmus

    # graphical stuff
    xss-lock
    i3lock-color
    feh
    light
    lxappearance

    bitwarden

    magic-wormhole

    texlive.combined.scheme-medium
  ];

  programs.zsh = {
    enable = true;
    defaultKeymap = "emacs";
    initExtra = ''eval "$(direnv hook zsh)"'';
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./p10k-config;
        file = "p10k.zsh";
      }
    ];
  };

  programs.git = {
    enable = true;
    userEmail = "relativistic.policeman@gmail.com";
    userName = "Ash";
  };

  programs.taskwarrior = {
    enable = true;
    config = {
      # No priority is higher than low priority.
      uda.priority.values = "H,M,,L";
    };
  };

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

    plugins = with (pkgs.vimPlugins // customVimPlugins); [
      # generally useful stuff
      vim-rooter
      vim-startify
      vim-sensible
      vim-python-pep8-indent

      # it's like a real IDE!
      vim-airline
      ale
      fugitive
      fzf-vim

      # language support
      vim-nix
      rust-vim

      # fast text editing
      vim-surround

      # Plugins
      iceberg-vim

      goyo-vim
      limelight-vim

      # Useful stuff for theme development.
      pgmnt-vim
      inspecthi-vim
      colorswatch-vim

      vim-eunuch
    ];
  };

  programs.kitty = {
    enable = true;
    settings = {
      background = "#100d15";
      background_opacity = "0.89";
      font_family = "Meslo LG M";
      font_size = "11.5";
    };
  };

  programs.rofi = {
    enable = true;
    theme = ./interstellar.rasi;
  };

  services.lorri.enable = true;

  services.picom = {
    enable = true;
    experimentalBackends = true;

    blur = true;
    vSync = true;
    backend = "glx";
    inactiveDim = "0.2";
    shadow = true;
    extraOptions = ''
      glx-no-stencil = true;
      blx-no-rebind-pixmap = true;
      blur: {
        method = "gaussian";
        size = 20;
        deviation = 10.0;
      }
    '';
  };

  services.dunst = {
    enable = true;
    settings = rec {
      global = {
        markup = "full";
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
            "xss-lock --transfer-sleep-lock -- i3lock-color -i ~/Documents/wallpapers/neon/neon-city.jpg";
          notification = false;
        }
        {
          command = "feh --bg-scale ~/Documents/wallpapers/neon/neon-city.jpg";
          always = true;
          notification = false;
        }
      ];

      gaps = {
        inner = 8;
        outer = 4;
      };
      window = {
        commands = [
          # Apparently you have to disable titlebars for i3-gaps. Dunno why.
          {
            command = "border pixel 0";
            criteria = { class = ".*"; };
          }
        ];
      };
    };
  };
}
