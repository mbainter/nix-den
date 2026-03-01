{ inputs, den, lib, ... }:
{
  flake-file.inputs.disko = {
    url = "github:nix-community/disko";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.disko = {
    nixos = { config, ... }: {
      imports = [ inputs.disko.nixosModules.disko ];
    };
  };
}
