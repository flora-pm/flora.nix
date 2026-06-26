{
  pkgs,
  lib,
  ...
}:
{
  assertions = [
    {
      assertion = pkgs ? postgresql_17;
      message = ''
        Flora needs postgresql version 17 to work.
      '';
    }
  ];

  postgresql = {
    enable = true;
    package = pkgs.postgresql_17;
    authentication = lib.mkOverride 10 ''
      local all       all     trust
      host  all       all     127.0.0.1/32   scram-sha-256
      host  all       all     ::1/128        scram-sha-256
    '';
  };
}
