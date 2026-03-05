{ opscraft, my, ... }:
{
  den.hosts.aarch64-darwin.vmacbook = {
    defaultBrightness = "80%";
    hostName = "MBainter1225m";
    users."mark.bainter".classes = [ "homeManager" ];
  };
}
