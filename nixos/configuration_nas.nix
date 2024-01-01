
{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Configure RAID
  boot.swraid = {
    enable = true; 
    mdadmConf = ''
      # automatically tag new arrays as belonging to the local system
      HOMEHOST <system>

      # instruct the monitoring daemon where to send mail alerts
      MAILADDR root

      # definitions of existing MD arrays
      ARRAY /dev/md0 level=raid1 num-devices=2 metadata=1.2 name=nixos:0 UUID=d407dcf9:a838fed1:09f83e48:a8f28456
    '';
  };

  # Mount the raid disk
  fileSystems."/raid" =
     { 
       device = "/dev/md0";
       fsType = "ext4";
       options = [
          "rw"
          "users"
          "x-systemd.automount"
       ];
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
  services.plex = {
    enable = true;
    openFirewall = true;
    group = "media";
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
