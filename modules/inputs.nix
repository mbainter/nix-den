# This repo was generated with github:vic/flake-file#dendritic template.
# Run `nix run .#write-flake` after changing any input.
#
# Inputs can be placed in any module, the best practice is to have them
# as close as possible to their actual usage.
# See: https://vic.github.io/dendrix/Dendritic.html#minimal-and-focused-flakenix
#
# For our template, we enable home-manager and nix-darwin by default, but
# you are free to remove them if not being used by you.
{ ... }:
{

  flake-file.inputs = {
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "https://flakehub.com/f/nix-darwin/nix-darwin/0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    ## these stable inputs are for wsl
    #nixpkgs-stable.url = "github:nixos/nixpkgs/release-25.05";
    #home-manager-stable.url = "github:nix-community/home-manager/release-25.05";
    #home-manager-stable.inputs.nixpkgs.follows = "nixpkgs-stable";

    #nixos-wsl = {
    #  url = "github:nix-community/nixos-wsl";
    #  inputs.nixpkgs.follows = "nixpkgs-stable";
    #  inputs.flake-compat.follows = "";
    #};

    # Secure Boot
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Deployment
    # deploy-rs = {
    #   url = "github:serokell/deploy-rs";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.utils.follows = "flake-utils";
    # };

    # nixos-anywhere = {
    #   url = "github:numtide/nixos-anywhere";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.disko.follows = "disko";
    # };

    # nixos-generators = {
    #   url = "github:nix-community/nixos-generators";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

}
