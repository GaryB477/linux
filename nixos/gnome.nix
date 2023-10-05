
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
      wofi # rofi, but wofi cus wayland :shrug:k

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

      # Wayland
      wofi # rofi, but wofi cus wayland :shrug:k
      grim # taking screenshots
      slurp # selecting a region to screenshot
      mako # the notification daemon, the same as dunst
      yad # a fork of zenity, for creating dialogs
    ];
  };
}