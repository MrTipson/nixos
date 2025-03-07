{ pkgs, lib, config, ... }:
{
  virtualisation.oci-containers.containers.grist = {
    image = "gristlabs/grist";
    ports = [ "8484:8484" ];
    volumes = [
      "/var/lib/grist:/persist"
    ];
    environment = {
      GRIST_SANDBOX_FLAVOR = "gvisor";
      GRIST_DOMAIN = "grist.local";  # subdomain you gave grist and your main domain (do not include https://)
      APP_HOME_URL = "https://grist.local";  # same as above but make sure it has https://
      APP_DOC_URL = "https://grist.local";  # as above, make sure it has https://
    };
  };

  systemd.services.mDNS-grist = lib.mkIf config.services.avahi.enable {
    enable = true;
    after = [ "docker-grist.service" ];
    wantedBy = [ "default.target" ];
    description = "mDNS grist advertisement";
    serviceConfig = {
      Type = "simple";
      ExecStart = ''${pkgs.avahi}/bin/avahi-publish -a -R grist.local 192.168.64.228'';
    };
  };

  services.caddy.virtualHosts."grist.local".extraConfig = ''
    reverse_proxy http://localhost:8484
  '';
}
