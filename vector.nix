{ pkgs, ... }:

{
  home.packages = [ pkgs.htop pkgs.powertop ];

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
}
