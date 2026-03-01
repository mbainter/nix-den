{ inputs, lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.hostConfig = mkOption {
    default = { };
    type = types.attrsOf (
      types.submodule {
        options = { };
      }
    );
  };
}
