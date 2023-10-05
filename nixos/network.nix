{ config, lib, pkgs, modulesPath, ... }:

{
  # Network
  # Enable networking
  networking.networkmanager.enable = true;
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Open ports for the external dispaly streaming devices --> Port 50051
  networking.firewall.allowedTCPPortRanges = [ { from = 50051; to = 50051; } ];
  networking.firewall.allowedUDPPortRanges = [ { from = 50051; to = 50051; } ];

  # enable the tailscale service
  services.tailscale.enable = true;

  users.users.marc = {
    packages = with pkgs; [
      # Networking packages
      networkmanagerapplet
      nettools
      inetutils
      tailscale

      ## VPN
      networkmanager-l2tp
      strongswan
    ];
  };
}
