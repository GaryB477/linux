{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  programs.hyprland.enable = true;

  # Use wayland as default
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
    });
  };

  # Since we dont use a full desktop, we need a ssh-agent (like, for interacting with git)
  programs.ssh.startAgent = true;
  systemd.user.services.add_ssh_keys = {
    script = ''
      eval "$(ssh-agent -s)"
      ssh-add $HOME/.ssh/id_ed25519
    '';
    wantedBy = ["graphical-session.target"]; #starts after login
  };

  users.users.marc = {
    packages = with pkgs; [
      kitty
      wofi # rofi, but wofi cus wayland :shrug:
      swaybg # the wallpaper
      swayidle # the idle timeout
      swaylock # locking the screen
      wlogout # logout menu
      wl-clipboard # copying and pasting
      wf-recorder # creen recording

      upower # Waybar applets
      gnome-power-manager # Waybar # Waybar applets

      # Debuggings tools
      # Waybar applets

      # Debuggings tools
      # Waybar applets

      # Debuggings tools
      libinput
    ];
  };
}
