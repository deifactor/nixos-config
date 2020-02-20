{ pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    # system monitors
    htop
    powertop

    # software dev tools
    ag
    kitty
    nixfmt
    rustup

    # chat clients
    discord
    tdesktop

    # chrome is necessary for granblue
    firefox
    google-chrome

    # tunes
    beets
    cmus

    # graphical stuff
    xss-lock
    feh
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

      # fast text editing
      vim-surround

      # Plugins
      iceberg-vim
    ];
  };

  programs.rofi = { enable = true; };

  services.compton = {
    enable = true;
    backend = "glx";
    shadow = true;
    fade = true;
    fadeDelta = 3;
    vSync = "true";
  };

  services.dunst = { enable = true; };

  services.flameshot = { enable = true; };

  services.polybar = {
    enable = true;
    package = pkgs.polybar.override { i3GapsSupport = true; };

    script = "polybar bar &";
    config = import ./polybar.nix;
  };

  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = "Mod4";
      keybindings = let modifier = "Mod4";
      in lib.mkOptionDefault {
        "${modifier}+d" = "exec --no-startup-id rofi -show drun";
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
