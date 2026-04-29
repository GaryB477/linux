
{ config, lib, pkgs, ... }:
{  
  virtualisation = {
    libvirtd = {
      enable = true;
      # Used for UEFI boot of Home Assistant OS guest image
      #qemuOvmf = true;
    };
  };

  environment.systemPackages = with pkgs; [
    # For virt-install
    virt-manager
    virt-viewer

    # For lsusb
    usbutils
  ];

  # Access to libvirtd
  users.users.marc= {
    extraGroups = ["libvirtd"];
  };

  # Bridge network configuration for Home Assistant VM
  networking.bridges.br0.interfaces = ["enp4s0"];
  networking.interfaces = {
    # Disable DHCP on the physical interface since it's now part of the bridge
    enp4s0.useDHCP = false;
    
    # Configure the bridge interface
    br0 = {
      useDHCP = false;
      ipv4.addresses = [{
        address = "192.168.0.50";
        prefixLength = 24;
      }
      {
        address = "192.168.0.34";
        prefixLength = 24;
      } 
      ];
    };
  };
  
  # Set default gateway and DNS servers
  networking.defaultGateway = {
    address = "192.168.0.254";
    interface = "br0";
  };
  
  # Configure DNS servers (using common public DNS servers as fallback)
  networking.nameservers = [ "8.8.8.8" "1.1.1.1" ];
}
