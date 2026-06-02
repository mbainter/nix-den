{ den, opscraft, ... }:
{
  flake-file.inputs = {
    microvm = {
      url = "github:microvm-nix/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  opscraft.microvm =
    { host, ... }:
    {
    };
}
