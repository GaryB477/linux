{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  services.xserver = {
    enable = true;
    xkb = {layout = "ch";};
    displayManager.startx.enable = true;
    displayManager.lightdm = {
      enable = true;
      greeter.enable = true;
    };
    # displayManager.gdm.enable = true;
    windowManager.openbox.enable = true;
  };

  services.autorandr = {
    enable = true;
  };
  security.polkit.enable = true;

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  # hardware.pulseaudio.enable = true;
  services.blueman.enable = true;

  users.users.marc = {
    packages = with pkgs; [
      obconf
      tint2
      xorg.xhost
      xorg.xprop
      wmctrl
      dmenu
      jumpapp
      xdotool
      autorandr
      arandr
      polkit
      feh # Wallpaper setter
      libsForQt5.spectacle # Screenshot utility

      dunst # Notification daemon
      picom # Compositor for Openbox
      xsecurelock  # Screen locker
      feh # Wallpaper setter

      bluez # Bluetooth utility
      blueman
      pavucontrol
    ];
  };
}
