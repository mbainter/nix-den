{ den, opscraft, ... }:
{
  den.hosts.x86_64-linux.vidar = {
    description = "NixOS Framework Laptop";
    isLaptop = true;
    users."mbainter" = { 
      description = "Mark Bainter";
      userNameNick = "mbainter";
      userNameReal = "Mark Bainter";
    };
  };

  den.aspects.vidar = {
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
    policies.to-mbainter =
      { host, user, ... }:
      lib.optional (user.name == "mbainter") (
        den.lib.policy.include {
	  # NOTE: this is just to demonstrate how I can configure something explicitly for my user on this host only
	  # This should be moved into my generic user.
          homeManager.programs.zoxide = {
            enable = user.name == "mbainter";

            enableBashIntegration = true;
            options = [
              "--cmd cd" #replace cd with z and zi (via cdi)
            ];
          };
        }
      );
  };

  includes = [
    den.aspects.disko
    den.aspects.nix
    opscraft.brightness
    (den.batteries.vm-autologin "mbainter")
    den.aspects.vidar.policies.to-mbainter
  ];
}
