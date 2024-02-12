
{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      ./qbittorrent.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Configure RAID
  #boot.swraid = {
  #  enable = true; 
  #  mdadmConf = ''
  #    # automatically tag new arrays as belonging to the local system
  #    HOMEHOST <system>
  #
  #      # instruct the monitoring daemon where to send mail alerts
  #      MAILADDR root
  #
  #      # definitions of existing MD arrays
  #      ARRAY /dev/md0 level=raid1 num-devices=2 metadata=1.2 name=nixos:0 UUID=d407dcf9:a838fed1:09f83e48:a8f28456
  #    '';
  #  };

  # Mount the raid disk
  #  fileSystems."/raid" =
  #     { 
  #       device = "/dev/md0";
  #       fsType = "ext4";
  #       options = [
  #          "rw"
  #          "users"
  #          "x-systemd.automount"
  #       ];
  #     };


  # Nvidia
  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
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
  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 563 8384 22000 30055 ];
    allowedUDPPorts = [ 563 22000 21027 30055 ];
  };

  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Configure keymap in X11
  services.xserver = {
    layout = "de";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "de";


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

  # Usenet and friends
  ## Services
  sonarr
  radarr
  bazarr
  jackett

  ## Downloader
  qbittorrent
  sabnzbd
 
  ## Streaming
  plex

  # File synthing
  syncthing

  ];
  };

  # port 8989 
  services.sonarr = {
    dataDir = "/var/lib/download/sonarr/.config/NzbDrone";
    enable = true;
    openFirewall = true;
    group = "media";
    user = "marc";
  };
  # port 7878
  services.radarr = {
    dataDir = "/var/lib/download/radarr/.config/Radarr";
    enable = true;
    openFirewall = true;
    group = "media";
    user = "marc";
  };
  # port 6767
  services.bazarr = {
    #dataDir = "/var/lib/download/bazarr";
    enable = true;
    openFirewall = true;
    group = "media";
    user = "marc";
  };
  # port 9117
  services.jackett= {
    dataDir = "/var/lib/download/jackett/.config/Jackett";
    enable = true;
    openFirewall = true;
    group = "media";
    user = "marc";
  };
  # port 9117
  # In file "/var/lib/sabnzbd/sabnzbd.ini" change the port from "127.0.0.1 or [::1]" to "0.0.0.0" to enable acces from non-local users (e.g. over networtk)
  services.sabnzbd = {
    configFile = "/var/lib/download/sabnzbd/sabnzbd.ini";
    enable = true;
    group = "media";
    user = "marc";
  };

  services.qbittorrent = {
    dataDir = "/var/lib/download/";
    enable = true;
    openFirewall = true;
    group = "media";
    user = "marc";
    port = 8728;
  };

  services.plex = {
    dataDir = "/var/lib/download/plex";
    enable = true;
    openFirewall = true;
    group = "media";
    user = "marc";
  };

  services = {
      syncthing = {
          enable = true;
          user = "marc";
          dataDir = "/home/marc/sync";    # Default folder for new synced folders
          configDir = "/home/marc/sync/.config/syncthing";   # Folder for Syncthing's settings and keys
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
  securityType = "user";
  extraConfig = ''
    # workgroup = WORKGROUP
    server string = smbnix
    netbios name = smbnix
    # security = user 
    #use sendfile = yes
    #max protocol = smb2
    # note: localhost is the ipv6 localhost ::1
    # hosts allow = 192.168.0.31 127.0.0.1 localhost
    # hosts deny = 0.0.0.0/0
    # guest account = nobody
    # map to guest = bad user
  '';
  shares = {
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

  users.groups.media = {};
  users.groups.media.members = [ "sonarr" "radarr" "bazarr" "jackett" "plex" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.X11Forwarding= true;

  system.stateVersion = "23.11"; # Did you read the comment?
}
