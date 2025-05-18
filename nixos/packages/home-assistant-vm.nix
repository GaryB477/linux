
{ config, lib, pkgs, ... }:
{  
  virtualisation = {
    libvirtd = {
      enable = true;
      # Used for UEFI boot of Home Assistant OS guest image
      qemuOvmf = true;
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
 # networking.defaultGateway.address = "10.0.0.1";
  networking.bridges.br0.interfaces = ["enp4s0"];
  networking.interfaces.br0 = {
    #useDHCP = false;
    ipv4.addresses = [{
      "address" = "192.168.0.50";
      "prefixLength" = 24;
    }];
  };
}
