{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  pritunl-client-mvr = pkgs.callPackage ../packages/pritunl.nix {};
  unstable = inputs.nixpkgsunstable;
in {
  imports = [
    # Include the results of the hardware scan.
    ../hardware-configurations/hardware-configuration_dell_dg.nix
    ../GUI/gnome.nix
    #../GUI/openbox.nix
    # ../packages/nvf-configuration.nix
    ../packages/edr.nix
    ../system/suspend-and-hibernate.nix
  ];

  # #
  # Boot loader
  # #

  # acpid
  services.acpid = {enable = true;};
  boot.loader.efi.canTouchEfiVariables = true;
  # Lanzaboote currently replaces the systemd-boot module.
  # This setting is usually set to true in configuration.nix
  # generated at installation time. So we force it to false
  # for now.
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    # Check initial status:
    # - bootctl status

    # Setup:
    # - sudo sbctl create-keys
    # - sudo sbctl setup --migrate # needed if some keys are already present or old

    # Verify:
    # - sudo sbctl verify
    # Note: It is expected that the files ending with bzImage.efi are not signed.
    # For me, some older generations were also not signed.

    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
  # Enable swap on luks
  boot.initrd.luks.devices."luks-8d8ffe68-aae3-4e00-8c75-36661c5eafd9".device = "/dev/disk/by-uuid/8d8ffe68-aae3-4e00-8c75-36661c5eafd9";

  # #
  # System setup
  # #
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
  # Enable the Flakes feature and the accompanying new nix command-line tool
  nix.settings.experimental-features = ["nix-command" "flakes"];
  time.timeZone = "Europe/Zurich";
  i18n.defaultLocale = "en_US.UTF-8";
  networking.hostName = "DG-BYOD-9364";
  virtualisation.docker.enable = true;

  # Nixpkgs setup
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

  # Console
  console = {useXkbConfig = true;};
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
    DOTNET_ROOT = "${pkgs.dotnetCorePackages.sdk_9_0_2xx}/share/dotnet";
  };

  # #
  # Graphics setup
  # #
  # Enable OpenGL
  # hardware.graphics = {enable = true;};
  # Load nvidia driver for Xorg and Wayland
  # services.xserver.videoDrivers = ["nvidia"];
  # hardware.nvidia = {
  #   modesetting.enable = true;
  #   powerManagement.enable = false;
  #   powerManagement.finegrained = false;
  #   open = false;
  #   nvidiaSettings = true;
  #   package = config.boot.kernelPackages.nvidiaPackages.stable;
  # };

  # #
  # Services
  # #
  services.printing.enable = true;
  services.hardware.bolt.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.upower.enable = true;
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  systemd.packages = [pritunl-client-mvr];
  systemd.targets.multi-user.wants = ["pritunl-client.service"];
  networking.networkmanager.enable = true;
  services.tailscale.enable = true;
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.X11Forwarding = true;

  # EDR setup
  programs.nix-ld.enable = true;
  edr.nix-alien-pkg = inputs.nix-alien.packages."${pkgs.system}".nix-alien;

  environment.systemPackages = with pkgs; [(python310.withPackages (ps: with ps; [pandas numpy gyp psutil]))];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.marc = {
    isNormalUser = true;
    description = "Hans Ruedi";
    extraGroups = ["networkmanager" "wheel" "docker" "storage"];
    packages = with pkgs; [
      # Boot
      # Unstable is needed since we need to migrate to the latest version to allow secure boot
      # https://github.com/nix-community/lanzaboote/issues/413#:~:text=You%20can%20also%20pull%20the%20latest%20sbctl%20from%20%3Cnixpkgs%2Dunstable%3E.
      (import inputs.nixpkgsunstable {inherit system;}).sbctl

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
          combinePackages [sdk_8_0 sdk_9_0 sdk_9_0_1xx sdk_9_0_2xx dotnet_10.sdk])

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
      vim
      neovim
      gh # GitHub cli
      git
      gitui
      gitg
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

      # General stuff
      google-chrome
      firefox
      _1password-gui
      obsidian
      spotify
      libreoffice
      drawio
      nautilus
      nemo-with-extensions
      evince # default gnome pdf viewer
      udisks # automount usb sticks

      # Work specific
      inputs.dg-cli.packages.${system}.default
      inputs.nix-alien.packages."${pkgs.system}".nix-alien
      (azure-cli.override {
        withExtensions = [azure-cli-extensions.azure-devops];
      })
      pritunl-client-mvr
      kubectl
      kubectx
      kubernetes-helm
      terraform
      corepack
      node-gyp
      (import inputs.nixpkgsunstable {inherit system;}).poetry
      unixODBC
      act # Github action on local machine
      azuredatastudio
      chromedriver
      postman
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
