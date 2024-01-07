
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
    allowedTCPPorts = [ 563 30055 ];
    allowedUDPPorts = [ 563 30055 ];
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
  ];
  };

  # port 8989 
  services.sonarr = {
    enable = true;
    openFirewall = true;
    group = "media";
  };
  # port 7878
  services.radarr = {
    enable = true;
    openFirewall = true;
    group = "media";
  };
  # port 6767
  services.bazarr = {
    enable = true;
    openFirewall = true;
    group = "media";
  };
  # port 9117
  services.jackett= {
    enable = true;
    openFirewall = true;
    group = "media";
  };
  # port 9117
  # In file "/var/lib/sabnzbd/sabnzbd.ini" change the port from "127.0.0.1 or [::1]" to "0.0.0.0" to enable acces from non-local users (e.g. over networtk)
  services.sabnzbd = {
    enable = true;
    group = "media";
  };

  services.qbittorrent = {
    enable = true;
    openFirewall = true;
    group = "media";
    port = 8728;
  };

  services.plex = {
    enable = true;
    openFirewall = true;
    group = "media";
  };

  services.tailscale.enable = true;

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
