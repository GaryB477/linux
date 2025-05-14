{ config, pkgs, inputs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ../hardware-configurations/hardware-configuration_nas.nix
    ../packages/qbittorrent.nix
    ../packages/r-suite_services.nix
    ../packages/homepage.nix
    (fetchTarball
      "https://github.com/nix-community/nixos-vscode-server/tarball/master")
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Nvidia
  # Enable OpenGL
  hardware.graphics.enable32Bit = true;
  hardware.graphics.enable = true;

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Setup for LVM
  # sudo pvcreate /dev/sda
  # sudo pvcreate /dev/sdb
  # sudo vgcreate pool /dev/sda /dev/sdb
  # sudo lvcreate -L 10G pool
  # sudo lvextend -l +100%FREE /dev/pool
  # sudo lvrename /dev/pool/lvol0 raid
  # sudo lvdisplay 
  # sudo mkfs.ext4 /dev/pool/home

  fileSystems."/raid" = {
    device = "/dev/pool/raid";
    fsType = "ext4";
  };

  # Enable networking
  networking.hostName = "nixos_nas"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 563 8384 22000 30055 ];
    allowedUDPPorts = [ 563 22000 21027 30055 8123 6052 ];
    # Allow Home Assistant access only from local network
    extraCommands = ''
      iptables -A INPUT -p tcp --dport 8123 -s 192.168.0.0/24 -j ACCEPT
      iptables -A INPUT -p tcp --dport 8123 -j DROP
    '';
  };

  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Configure keymap in X11
  services.xserver = {
    xkb = {
      variant = "";
      layout = "de";
    };
  };
  console.keyMap = "de";

  services.vscode-server.enable = true;

  # Add docker support
  virtualisation.docker.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.marc = {
    isNormalUser = true;
    description = "Marc Röthlisberger";
    extraGroups = [ "networkmanager" "wheel" "docker" "media" ];

    packages = with pkgs; [

      # System stuff
      vim
      git
      mdadm
      gparted
      tree
      tailscale
      zip
      toybox
      borgbackup
      nixfmt-classic
      nmap

      esphome

      # Usenet and friends
      ## Services
      sonarr
      radarr
      bazarr
      jellyseerr

      ## Downloader
      qbittorrent
      sabnzbd

      ## Streaming
      plex

      # File synthing
      syncthing
    ];
  };

  services = {
    syncthing = {
      enable = true;
      user = "marc";
      dataDir = "/home/marc/sync"; # Default folder for new synced folders
      configDir =
        "/home/marc/sync/.config/syncthing"; # Folder for Syncthing's settings and keys
      guiAddress = "0.0.0.0:8384";
    };
  };

  services.tailscale.enable = true;

  # Netowrk share
  ## Setup
  # - Add a password to the user with `smbpasswd -a <user>`
  # - Mount the network share under windows with `\\<server-ip>\raid´

  services.samba.openFirewall = true;
  networking.firewall.allowPing = true;
  services.samba-wsdd = {
    # make shares visible for Windows clients
    enable = true;
    openFirewall = true;
  };
  services.samba = {
    enable = true;
    settings = {
      global = {
        "securityType" = "user";
        "server string" = "smbnix";
        "netbios name" = "smbnix";
      };
      raid = { # <-- Name of the share!
        path = "/raid";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        #"force user" = "username";
        #"force group" = "groupname";
      };
    };
  };

  # Enable cron service
  services.cron = {
    enable = true;
    systemCronJobs = [
      "0 4 * * *      marc   zip -r /home/marc/sync/usenet_backup_$(date +%F_%R).zip /var/lib/download/ -x '*plex*' -x '*MediaCover*'"
    ];
  };

  virtualisation.oci-containers.containers."esphome" = {
    image = "ghcr.io/esphome/esphome:2025.2.0";
    environment = {
      "ESPHOME_DASHBOARD_USE_PING" = "true";
    };
    volumes = [
      "/var/lib/esphome:/config"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network=host"
      "--privileged"
    ];
    #ports = ["0.0.0.0:6052:6052"]; 
  };

  services.home-assistant = {
    enable = true;
    openFirewall = true;
    extraComponents = [
      # Components required to complete the onboarding
      "analytics"
      "esphome"
      "google_translate"
      "met"
      "shopping_list"
      # Recommended for fast zlib compression
      "isal"
    ];
    config = {
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
      default_config = { };
      http = {
        server_host = "0.0.0.0";
        #  trusted_proxies = [ "::" ];
        #  use_x_forwarded_for = true;
      };
    };
  };

  #services.nginx = {
  #  recommendedProxySettings = true;
  #  virtualHosts."home.example.com" = {
  #    forceSSL = true;
  #    enableACME = true;
  #    extraConfig = ''
  #      proxy_buffering off;
  #    '';
  #    locations."/" = {
  #      proxyPass = "http://[::1]:8123";
  #      proxyWebsockets = true;
  #    };
  #  };
  #};

  users.groups.media = { };
  users.groups.media.members = [ "sonarr" "radarr" "bazarr" "jackett" "plex" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable the Flakes feature and the accompanying new nix command-line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.X11Forwarding = true;

  system.stateVersion = "23.11"; # Did you read the comment?
  system.autoUpgrade.enable = true;

}
