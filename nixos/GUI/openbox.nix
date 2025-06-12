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
    displayManager.lightdm = {
      enable = true;
      greeter.enable = true;
    };
    # displayManager.gdm.enable = true;
    windowManager.openbox.enable = true;
  };

  #services.autorandr = {
  #enable = true;
  # Usage: create setup as desired with xrandr.
  # E.g.:
  # `xrandr --output HDMI-0 --mode 3840x2160 --rate 120`
  # `xrandr --output DP-0 --mode 2560x1440 --rate 120 --rotate left`
  # Then be sure to updte the config in the dotfiles repo
  #};
  security.polkit.enable = true;

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
      feh

      picom
    ];
  };
}
