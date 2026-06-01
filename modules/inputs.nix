# This repo was generated with github:vic/flake-file#dendritic template.
# Run `nix run .#write-flake` after changing any input.
#
# Inputs can be placed in any module, the best practice is to have them
# as close as possible to their actual usage.
# See: https://denful.dev/Dendritic.html#minimal-and-focused-flakenix
#
# For our template, we enable home-manager and nix-darwin by default, but
# you are free to remove them if not being used by you.
{ lib, ... }:
{

  flake-file.inputs = {
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixpkgs.url = "github:nixos/nixpkgs/release-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
       url = "github:nix-community/home-manager/release-26.05";
       inputs.nixpkgs.follows = "nixpkgs";
     };

     darwin = {
       url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
       inputs.nixpkgs.follows = "nixpkgs";
     };

     # NOTE: for switching to determinate nix for all sources:
     # nixpkgs.url = lib.mkForce "https://flakehub.com/f/NixOS/nixpkgs/0";
     # nixpkgs-unstable.url = lib.mkForce "https://flakehub.com/f/NixOS/nixpkgs/0.1";

     # home-manager = {
     #   url = "https://flakehub.com/f/nix-community/home-manager/0";
     #   inputs.nixpkgs.follows = "nixpkgs";
     # };

     # darwin = {
     #   url = "https://flakehub.com/f/nix-darwin/nix-darwin/0";
     #   inputs.nixpkgs.follows = "nixpkgs";
     # };

     #nixos-wsl = {
     #  url = "github:nix-community/nixos-wsl";
     #  inputs.nixpkgs.follows = "nixpkgs";
     #  inputs.flake-compat.follows = "";
     #};

     # Secure Boot
     lanzaboote = {
       url = "github:nix-community/lanzaboote";
       inputs.nixpkgs.follows = "nixpkgs";
     };
  };
}
