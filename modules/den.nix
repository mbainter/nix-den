{ lib, ... }:
{
  den.homes = {
    x86_64-linux.mbainter = { };
    aarch64-darwin."mark.bainter" = { };
  };

  # enable hm for all users
  den.schema.user.classes = lib.mkDefault [ "homeManager" ];
}
