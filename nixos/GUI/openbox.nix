{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  services.xserver = {
    enable = true;
    xkb = { layout = "ch"; };
    displayManager.lightdm.enable = true;
    windowManager.openbox.enable = true;
  };

  users.users.marc = {
    packages = with pkgs; [
      obconf
      tint2
      xorg.xhost
      picom
      wmctrl
      dmenu
      jumpapp
      xdotool
      autorandr
      arandr
      polkit
    ];
  };
}
