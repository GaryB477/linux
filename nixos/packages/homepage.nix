{ config, lib, pkgs, ... }: {
  services.homepage-dashboard = {
    # These options were already present in my configuration.
    enable = true;
    # package = unstable.homepage-dashboard;
    openFirewall = true;

    # The following options were what I planned to add.

    # https://gethomepage.dev/latest/configs/settings/
    settings = { };

    # https://gethomepage.dev/latest/configs/bookmarks/
    bookmarks = [ ];

    # https://gethomepage.dev/latest/configs/services/
    services = [ ];

    # https://gethomepage.dev/latest/configs/service-widgets/
    widgets = [
        {
          resources = {
            expanded = true;
            label = "System";
            cpu = true;
            disk = "/";
            memory = true;
          };
        }
        { 
          resources = {
            expanded = true;
            label = "Raid";
            disk = "/raid";
          };
        }
        { 
          # widget = {
          #   type = sonarr;
          #   url = "http://sonarr.host.or.ip";
          #   key = "8cda4e82b6584d52b2ed2e46113900c1";
          #   enableQueue = true; # optional, defaults to false
          # };
          sonarr = {
            url = "http://sonarr.host.or.ip";
            key = "8cda4e82b6584d52b2ed2e46113900c1";
            enableQueue = true; # optional, defaults to false
          };
        }
      ];

    # https://gethomepage.dev/latest/configs/kubernetes/
    kubernetes = { };

    # https://gethomepage.dev/latest/configs/docker/
    docker = { };

    # https://gethomepage.dev/latest/configs/custom-css-js/
    customJS = "";
    customCSS = "";
  };
}
