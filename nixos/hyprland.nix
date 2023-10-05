
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

      upower # Waybar applets
      gnome.gnome-power-manager # Waybar applets
    ];
  };
}