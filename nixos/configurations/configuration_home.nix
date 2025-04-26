{ config, pkgs, lib, inputs, ... }:
let
  pritunl-client-mvr = pkgs.callPackage ../packages/pritunl.nix { };
in {
  imports = [
    # Include the results of the hardware scan.
    ../hardware-configurations/hardware-configuration_home.nix
    # ../GUI/gnome.nix
    ../GUI/openbox.nix
    # ../GUI/hyprland.nix
    ../packages/nvf-configuration.nix
    #../packages/edr.nix
  ];
  # acpid
  services.acpid = { enable = true; };

  # Bootloader.
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      devices = [ "nodev" ];
      efiSupport = true;
      useOSProber = true;
      # fsIdentifier = "label";
      # efiInstallAsRemovable = true;
      gfxmodeEfi = "3440x1440";
      fontSize = 36;
    };
  };
  environment.systemPackages = with pkgs;
    [ (python310.withPackages (ps: with ps; [ pandas numpy gyp psutil ])) ];

  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "--no-write-lock-file"
      "-L" # print build logs
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-d0aa1b0d-6d29-4561-b7b3-748a7393c9e9".device =
    "/dev/disk/by-uuid/d0aa1b0d-6d29-4561-b7b3-748a7393c9e9";
  # Set your time zone.
  time.timeZone = "Europe/Zurich";
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };
  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Configure console keymap
  console = { useXkbConfig = true; };

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
  };

  # Add docker support
  virtualisation.docker.enable = true;

  programs.nix-ld.enable = true;
  services.upower.enable = true;
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "openssl-1.1.1w" # for sublime4
      "nodejs-14.21.3"
      "openssl-1.1.1u"
      "electron-13.6.9"
      "qtwebkit-5.212.0-alpha4"
    ];
  };

  # Enable the Flakes feature and the accompanying new nix command-line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Change default shell
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;
  programs.zsh.autosuggestions.enable = true;
  programs.zsh.syntaxHighlighting.enable = true;
  programs.zsh.ohMyZsh = {
    enable = true;
    plugins = [ "git" "z" "fzf" ];
    theme = "agnoster";
  };

  environment.shells = with pkgs; [ zsh ];
  environment.sessionVariables = {
    DOTNET_ROOT = "${pkgs.dotnetCorePackages.sdk_9_0_2xx}/share/dotnet";
  };
  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS =
      "/home/marc/.steam/root/compatibilitytools.d";
  };

  # EDR needs nix-alien
  #edr.nix-alien-pkg = inputs.nix-alien.packages."${pkgs.system}".nix-alien;

  networking.hostName = "DG-BYOD-9364"; # Define your hostname.

  # Pritunl does not add its service by itself
  systemd.packages = [ pritunl-client-mvr ];
  systemd.targets.multi-user.wants = [ "pritunl-client.service" ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.marc = {
    isNormalUser = true;
    description = "Hans Ruedi";
    extraGroups = [ "networkmanager" "wheel" "docker" "storage" ];
    packages = with pkgs; [
      # Storage
      cifs-utils

      # Frontend for wayland
      kanshi # autorandr for wayland
      wl-clipboard # clipboard for wayland
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

      vscode-fhs # Allows for plugins to be installed and work...
      teams-for-linux
      remmina
      pulseaudio

      gh # GitHub cli
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
      nixfmt-classic

      ## Kubernetes
      kubectl
      kubernetes
      minikube
      google-cloud-sdk

      ## C scharf
      (with pkgs.dotnetCorePackages;
        combinePackages [ sdk_8_0 sdk_9_0 sdk_9_0_1xx sdk_9_0_2xx ])

      # postgres
      postgresql

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
      just
      btop
      broot
      lazydocker
      vimPlugins.vim-plug
      fzf
      tmux
      screen
      nix-search
      usbutils # displays more info about usb devices
      s-tui
      alacritty
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
      discord
      protonup
      #steam
      #(steam.override
      #{extraLibraries = pkgs: [pkgs.gperftools];})
      mangohud
      vulkan-tools
      lutris
      webcord
      libreoffice
      drawio
      nautilus
      nemo-with-extensions
      evince # default gnome pdf viewer
      udisks # automount usb sticks

      # Work specific
      #inputs.dg-cli.packages.${system}.default
      inputs.nix-alien.packages."${pkgs.system}".nix-alien
      (azure-cli.override {
        withExtensions = [ azure-cli-extensions.azure-devops ];
      })
      pritunl-client-mvr
      kubectl
      kubectx
      kubernetes-helm
      terraform
      corepack
      nodejs_23
      node-gyp
      poetry
      unixODBC
      act # Github action on local machine
      azuredatastudio
    ];
  };

  # Fonts. Corefonts contain the webdings fonts needed by some Medivation documents, like the risk analysis
  fonts.packages = with pkgs; [ nerdfonts corefonts ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
