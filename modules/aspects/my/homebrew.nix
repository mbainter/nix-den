{ den, lib, inputs, ... }:
{
  flake-file.inputs = {
    brew-api = {
      url = "github:BatteredBunny/brew-api";
      flake = false;
    };

    brew-nix = {
      url = "github:BatteredBunny/brew-nix";
      inputs.brew-api.follows = "brew-api";
    };
  };

  darwin =
    { config, lib, pkgs, ... }:
    {
      homebrew = {
        enable = lib.mkDefault true;

        onActivation = {
          autoUpdate = lib.mkDefault true;
          cleanup = lib.mkDefault "zap";
        };

        caskArgs = {
          appdir = lib.mkDefault "~/Applications";
          require_sha = lib.mkDefault true;
        };
    };
}
