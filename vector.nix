{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    # system monitors
    htop
    powertop

    # chat clients
    discord
    tdesktop

    # chrome is necessary for granblue
    firefox
    google-chrome

    # tunes
    beets cmus
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

  programs.rofi = {
    enable = true;
  };

  services.compton = {
    enable = true;
    backend = "glx";
    shadow = true;
    fade = true;
    fadeDelta = 3;
  };

  services.dunst = {
    enable = true;
  };

  services.flameshot = {
    enable = true;
  };

  services.polybar = {
    enable = true;
    package = pkgs.polybar.override {
      i3GapsSupport = true;
    };

    script = "polybar bar &";
    config = import ./polybar.nix;
  };
}
