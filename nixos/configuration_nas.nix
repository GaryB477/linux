
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
  fileSystems."/home/marc/raid" =
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
    extraGroups = [ "networkmanager" "wheel" "docker" ];

  packages = with pkgs; [
  vim 
  git
  mdadm
  gparted
  ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.X11Forwarding= true;

  system.stateVersion = "23.11"; # Did you read the comment?
}
