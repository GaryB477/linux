
{ config, lib, pkgs, modulesPath, ... }:

{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # services.xserver.videoDrivers = [ "displaylink" "modesetting" ];

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "de";
    xkbVariant = "";
  };


  users.users.marc = {
    packages = with pkgs; [

      # Frontend for X11 
      gnome3.gnome-tweaks
      jumpapp
      xorg.xhost
      xdotool
      wmctrl
      xbindkeys
      autorandr
      arandr
      xorg.xhost
      polkit

    ];
  };
}