{ inputs, den, lib, ... }:
{
  flake-file.inputs.determinate = {
    url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
  };

  # full determinate-nix configuration
  den.aspects.determinate = {
    # Darwin-specific configuration
    darwin = { config, pkgs, ... }: {
      imports = [ inputs.determinate.darwinModules.default ];

      determinateNix = {
        enable = true;

        customSettings = {
          # See https://jackson.dev/post/nix-reasonable-defaults/
          connect-timeout = 5;
          log-lines = 25;
          min-free = 128000000; # 128MB
          max-free = 1000000000; # 1GB
          download-buffer-size = 524288000; # 500MB

          eval-cores = 0;
          lazy-trees = true;
          warn-dirty = false;

          auto-optimise-store = true;
          max-jobs = "auto";

          experimental-features = [
            "nix-command"
            "flakes"
          ];

          extra-experimental-features = [
            "build-time-fetch-tree" # Enables build-time flake inputs
            "parallel-eval" # Enables parallel evaluation
          ];

          substituters = [
            # high priority since it's almost always used
            # "http://192.168.88.170:8180/darwin"
            "https://cache.nixos.org?priority=10"
            "https://install.determinate.systems"
            "https://nix-community.cachix.org"
          ];

          trusted-public-keys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM"
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          ];
        };

        determinateNixd = {
          garbageCollector.strategy = "optimized";
        };
      };

      nixpkgs.overlays = [
        (final: _prev: {
          unstable = import inputs.nixpkgs-unstable {
            inherit (final) config system;
          };
        })
      ];

      environment.systemPackages = with inputs.nix-darwin.packages.${pkgs.stdenv.hostPlatform.system}; [
        darwin-option
        darwin-rebuild
        darwin-version
        darwin-uninstaller
      ];
    };

    # NixOS configuration
    nixos = { ... }: {
      imports = [ inputs.determinate.nixosModules.default ];

      determinateNix = {
        enable = true;
        customSettings = {
          auto-optimise-store = true;
          max-jobs = "auto";
        };
      };

      nixpkgs.overlays = [
        (final: _prev: {
          unstable = import inputs.nixpkgs-unstable {
            inherit (final) config system;
          };
        })
      ];
    };
  };

  den.aspects.determinate-minimal = {
    darwin = _: {
      nix.enable = false;  # Just disable nix-darwin's Nix management
    };

    homeManager = _: {
      nix.package = null;  # Don't manage Nix package
    };
  };
}
