
{ config, lib, pkgs, modulesPath, ... }:

{
  # Enable hyperland
  # hyprland
  programs.hyprland = {
     enable = true;
     xwayland = {
       enable = true;
       hidpi = false;
   };
  };

  programs.waybar = {
      enable = true;
      package = pkgs.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
  };

  users.users.marc = {
    packages = with pkgs; [
      wofi # rofi, but wofi cus wayland :shrug:k
      swaybg # the wallpaper
      swayidle # the idle timeout
      swaylock # locking the screen
      wlogout # logout menu
      wl-clipboard # copying and pasting
      wf-recorder # creen recording
      grim # taking screenshots
      slurp # selecting a region to screenshot
      mako # the notification daemon, the same as dunst
      yad # a fork of zenity, for creating dialogs

      upower # Waybar applets
      gnome.gnome-power-manager # Waybar applets
    ];
  };
}