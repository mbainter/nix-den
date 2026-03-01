{ den, my, ... }:
{
  den.aspects.tyr = {
    includes = [
      den.aspects.disko
      my.networking
    ];

    # tyr host provides some home-manager defaults to its users.
    homeManager.programs.direnv.enable = true;

    # NixOS configuration for tyr.
    nixos =
      { inputs, pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.hello ];

        networking.hostId = "daea5664";

        nixpkgs.overlays = [
          (final: _prev: {
            unstable = import inputs.nixpkgs-unstable {
              inherit (final) config system;
            };
          })
        ];
      };

    # <host>.provides.<user>, via opscraft/routes.nix
    provides.mbainter =
      { user, ... }:
      {
        homeManager.programs.zoxide = {
          enable = user.name == "mbainter";
        };

        # FIXME: condition this on shell
        enableBashIntegration = true;
        options = [
          "--cmd cd" #replace cd with z and zi (via cdi)
        ];
      };
  };
}
