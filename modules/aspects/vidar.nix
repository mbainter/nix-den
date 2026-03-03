{ den, opscraft, ... }:
{
  den.aspects.vidar = {
    includes = [
      den.aspects.disko
      den.aspects.nix
      opscraft.brightness
    ];

    # vidar host provides some home-manager defaults to its users.
    homeManager.programs.direnv.enable = true;

    # NixOS configuration for vidar.
    nixos =
      { inputs, pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.hello ];
        hardware.enableRedistributableFirmware = true;

        networking.hostId = "7210ac3f";

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
