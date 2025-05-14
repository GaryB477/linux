{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  # port 8989 
  services.sonarr = {
    dataDir = "/var/lib/download/sonarr/.config/NzbDrone";
    enable = true;
    openFirewall = true;
    group = "media";
    user = "marc";
  };
  # port 7878
  services.radarr = {
    dataDir = "/var/lib/download/radarr/.config/Radarr";
    enable = true;
    openFirewall = true;
    group = "media";
    user = "marc";
  };
  # port 6767
  services.bazarr = {
    #dataDir = "/var/lib/download/bazarr";
    enable = true;
    openFirewall = true;
    group = "media";
    user = "marc";
  };
  # port 9117
  services.jackett= {
    # Did overwrite since channel 24.11 used a 863 or whatever version, which had non-passing tests.
    package = inputs.nixpkgsunstable.legacyPackages.${pkgs.system}.jackett;
    enable = true;
    openFirewall = true;
    group = "media";
    user = "marc";
  };
  # port 9117
  # In file "/var/lib/sabnzbd/sabnzbd.ini" change the port from "127.0.0.1 or [::1]" to "0.0.0.0" to enable acces from non-local users (e.g. over networtk)
  services.sabnzbd = {
    configFile = "/var/lib/download/sabnzbd/sabnzbd.ini";
    enable = true;
    group = "media";
    user = "marc";
  };

  services.qbittorrent = {
    dataDir = "/var/lib/download/";
    enable = true;
    openFirewall = true;
    group = "media";
    user = "marc";
    port = 8728;
  };

  services.plex = {
    dataDir = "/var/lib/download/plex";
    enable = true;
    openFirewall = true;
    group = "media";
    user = "marc";
  };

  services.jellyseerr = {
    enable = true;
    openFirewall = true;
    port = 8730;
  };
}
