# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  # betray my principles for gamer chat
  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth.enable = true;

  hardware.cpu.intel.updateMicrocode = true;
  hardware.opengl.driSupport32Bit = true;

  networking.hostName = "superluminal-steel"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s25.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # chrome is necessary for granblue
    firefox libinput google-chrome

    # Nerd shit for nerds
    vim neovim kitty mosh git toilet
    pciutils usbutils cmus
    fzf ag
    rustup

    # Chat clients
    discord tdesktop

    # Utilities
    keepassxc wget file nix-index killall xss-lock
    htop

    # Desktop utilities
    rofi
    (polybar.override { i3GapsSupport = true; mpdSupport = true; pulseSupport = true; })
    flameshot

    syncthing

    # aesthetic
    feh
    pywal
    (dunst.override { dunstify = true; })

    # tunes
    beets ncmpcpp

    # build stuff. these are installed so i don't need to install them *every*
    # single time, but libraries should probably go in a shell.nix.
    binutils gcc gnumake openssl pkgconfig

    steam
  ];

  fonts.fonts = with pkgs; [
    unifont
    siji
    meslo-lg
    (nerdfonts.override { withFont = "Iosevka"; })
  ];

  console.useXkbConfig = true;

  environment.sessionVariables = {
    TERMINAL = "kitty";
    EDITOR = "nvim";
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  systemd.user.services.dunst = {
    enable = true;
    description = "Shows notifications.";
    wantedBy = [ "default.target" ];
    serviceConfig.Restart = "always";
    serviceConfig.RestartSec = 2;
    serviceConfig.ExecStart = "${pkgs.dunst}/bin/dunst";
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  programs.light.enable = true;

  services.xserver = {
    enable = true;
    libinput.enable = true;
    desktopManager = {
      xterm.enable = false;
    };

    xkbOptions = "ctrl:nocaps";

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps; 
    };

    displayManager.defaultSession = "none+i3";
  };

  services.compton = {
    enable = true;
    vSync = true;
    backend = "glx";
    shadow = true;
    fade = true;
    fadeDelta = 3;
    wintypes = {
      dock = { shadow = false; };
    };
  };

  services.syncthing = {
    enable = true;

    user = "brightflame";
    dataDir = "/home/brightflame/.syncthing";
  };

  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/6ea80150-a194-4f2c-a291-c0490efa75a0";
      preLVM = true;
      allowDiscards = true;
    };
  };

  programs.zsh.enable = true;

  powerManagement.cpuFreqGovernor = "performance";

  users.groups.video = {};

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.brightflame = {
     isNormalUser = true;
     extraGroups = [ "video" "wheel" ]; # Enable ‘sudo’ for the user.
     shell = pkgs.zsh;
  };

  users.users.vector = {
     isNormalUser = true;
     extraGroups = [ "video" "wheel" ];
     shell = pkgs.zsh;
  };

  home-manager.users.vector = import ./vector.nix;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}

