{ inputs, den, lib, ... }:
{
  den.aspects.nix = {
    nixos = { config, pkgs, ... }: {
      nix = {
        settings = {
          # See https://jackson.dev/post/nix-reasonable-defaults/
          connect-timeout = 5;
          log-lines = 25;
          min-free = 128000000; # 128MB
          max-free = 1000000000; # 1GB
          download-buffer-size = 524288000; # 500MB

          # Deduplicate and optimize nix store
          auto-optimise-store = true;

          experimental-features = [ "nix-command" "flakes" ];
          warn-dirty = false;

          substituters = [
            "http://192.168.88.170:8180/nixos"
            "https://nix-community.cachix.org"
            "https://cache.garnix.io"
            "https://cache.nixos.org"
          ];    

          trusted-public-keys = [
             "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
             "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
             "nixos:/Bjs+tZUAF5qgnTAKqyhvcCknR5amb7lzpV5uWHtiGQ="
          ];
        };

        #extraOptions = ''
        #  !include ${config.sops.templates.nix-access-tokens.path }
        #'';

        # Garbage Collection
        gc = {
          automatic = true;
          options = "--delete-older-than 10d";
        };
      };
    };
  };
}
