# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.

  # The raid was created with mdadm using this command:
  # sudo mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sda /dev/sdb
  # Note: check the sdX values to ensure the correct deviecs are selected when creating!
  fileSystems."/home/marc/raid" =
    { device = "/dev/md0";
      fsType = "ext4";
    };


  # Enable networking
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
