# DO-NOT-EDIT. This file was auto-generated using github:vic/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  inputs = {
    darwin = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "https://flakehub.com/f/nix-darwin/nix-darwin/0";
    };
    den.url = "github:vic/den";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
    flake-aspects.url = "github:vic/flake-aspects";
    flake-file.url = "github:vic/flake-file";
    flake-parts = {
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
      url = "github:hercules-ci/flake-parts";
    };
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/release-25.11";
    };
    import-tree.url = "github:vic/import-tree";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-lib.follows = "nixpkgs";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

}
