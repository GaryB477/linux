{
  config,
  pkgs,
  lib,
  ...
}: let
  unstable = import <nixos-unstable> {config = {allowUnfree = true;};};
  dg-cli = pkgs.callPackage ./packages/dg-cli.nix {};
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configurations/hardware-configuration_dell_dg.nix
    ./gnome.nix
    ./nvf-configuration.nix
  ];

  # acpid
  services.acpid = {
    enable = true;
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  environment.systemPackages = with pkgs; [
    (python310.withPackages (ps:
      with ps; [
        pandas
        numpy
      ]))
  ];

  # Enable swap on luks
  boot.initrd.luks.devices."luks-4b7d39ae-45a9-4eff-99dd-007ddd87e43c".device = "/dev/disk/by-uuid/4b7d39ae-45a9-4eff-99dd-007ddd87e43c";

  # Set your time zone.
  time.timeZone = "Europe/Zurich";
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Configure console keymap
  console = {
    useXkbConfig = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable support for thunderbolt - used for docking stations
  services.hardware.bolt.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Add docker support
  virtualisation.docker.enable = true;

  programs.nix-ld.enable = true;
  services.upower.enable = true;
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable the Flakes feature and the accompanying new nix command-line tool
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Change default shell
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;
  programs.zsh.autosuggestions.enable = true;
  programs.zsh.syntaxHighlighting.enable = true;
  programs.zsh.ohMyZsh = {
    enable = true;
    plugins = ["git" "z" "fzf"];
    theme = "agnoster";
  };

  environment.shells = with pkgs; [zsh];
  environment.sessionVariables = {
    DOTNET_ROOT = "${pkgs.dotnet-sdk}/share/dotnet";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.marc = {
    isNormalUser = true;
    description = "Hans Ruedi";
    extraGroups = ["networkmanager" "wheel" "docker" "storage"];
    packages = with pkgs; [
      # Storage
      cifs-utils

      # Frontend for wayland
      kanshi #autorandr for wayland
      wl-clipboard #clipboard for wayland
      wev # wayland event viewer
      wdisplays # wayland version of arandr
      wlr-randr # wayland xrandr
      wlrctl # Command line utility for miscellaneous wlroots Wayland extensions

      # audio
      alsa-utils # provides amixer/alsamixer/...
      playerctl # Command-line utility and library for controlling media players that implement MPRIS
      mpd # for playing system sounds
      mpc-cli # command-line mpd client
      ncmpcpp # a mpd client with a UI
      networkmanagerapplet # provide GUI app: nm-connection-editor

      # Terminal
      vimPlugins.vim-plug
      fzf
      tmux

      vscode-fhs # Allows for plugins to be installed and work...
      git
      gitg
      gitkraken
      gimp
      docker
      docker-compose
      pandoc
      rpi-imager
      gparted
      meld
      glxinfo
      kooha
      jetbrains-toolbox
      dpkg

      # Development environment
      acpid # A daemon for delivering ACPI events to userspace programs
      patchelf
      steam-run
      stdenv
      xvfb-run
      fuse
      pmutils # A small collection of scripts that handle suspend and resume on behalf of HAL

      ## Kubernetes
      kubectl
      kubernetes
      minikube
      google-cloud-sdk

      ## C sharp
      dotnet-sdk_9
      #dotnet-sdk_8
      dotnetCorePackages.sdk_8_0_3xx

      ## CPP
      cmake
      gdb
      gcc
      gnumake
      doxygen

      # Power management testing
      powertop
      stress
      geekbench_5

      # Terminal
      kitty
      zsh
      neofetch
      trash-cli
      killall
      s-tui
      htop
      tree
      zip
      unzip
      xclip
      toybox
      jq # A lightweight and flexible command-line JSON processor
      socat
      stow # GNU stow for managing symlinked dot files
      copyq # Clipboard manager. Should help in case some app does store to a differen registry insead of using the global one...

      # Generla stuff
      google-chrome
      firefox
      _1password-gui
      obsidian
      spotify
      slack
      libreoffice
      drawio
      nautilus
      nemo-with-extensions
      evince # default gnome pdf viewer
      udisks # automount usb sticks

      # Work specific
      dg-cli
    ];
  };

  nixpkgs.config.permittedInsecurePackages = [
    "nodejs-14.21.3"
    "openssl-1.1.1u"
    "electron-13.6.9"
    "qtwebkit-5.212.0-alpha4"
  ];

  # Fonts. Corefonts contain the webdings fonts needed by some Medivation documents, like the risk analysis
  fonts.packages = with pkgs; [
    nerdfonts
    corefonts
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
