{config, lib, pkgs, ...}:
{
  systemd.user.services.solaar = {
    enable = true;
    description = "Solaar service";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.solaar}/bin/solaar -w hide -b symbolic";
    };
  };
}