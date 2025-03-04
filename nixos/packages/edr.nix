{
  config,
  lib,
  ...
}: {
  options.edr.nix-alien-pkg = lib.mkOption {
    type = lib.types.package;
  };

  # DG Elastic EDR Agent
  # Steps to install:
  # - download from https://www.elastic.co/downloads/elastic-agent and extract into /opt/Elastic/Agent
  # - enroll with: sudo nix-alien /opt/Elastic/Agent/elastic-agent enroll --url=... --enrollment-token=...
  config.systemd.services.elastic-agent = {
    description = "Elastic Agent is a unified agent to observe, monitor and protect your system.";
    serviceConfig = {
      StartLimitIntervalSec = 5;
      StartLimitBurst = 10;
      ExecStart = ''${config.edr.nix-alien-pkg}/bin/nix-alien /opt/Elastic/Agent/elastic-agent'';
      WorkingDirectory = "/opt/Elastic/Agent";
      Restart = "always";
      KillMode = "process";
      RestartSec = 120;
      EnvironmentFile = "-/etc/sysconfig/elastic-agent";
      Environment = "PATH=/run/wrappers/bin:/nix/profile/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin";
    };
    wantedBy = ["multi-user.target"];
  };
}
