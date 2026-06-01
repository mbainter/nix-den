{ den, opscraft, my, inputs, ... }:
{
  den.hosts.x86_64-linux.tyr = {
    description = "NixOS GMKtek Desktop";
    users."mbainter" = { 
      description = "Mark Bainter";
      userNameNick = "mbainter";
      userNameReal = "Mark Bainter";
    };
  };

  den.aspects.tyr = {
    # tyr host provides some home-manager defaults to its users.
    homeManager.programs.direnv.enable = true;

    # NixOS configuration for tyr.
    nixos =
      { pkgs, ... }:
      {
        imports = with inputs.nixos-hardware.nixosModules; [
          common-cpu-amd
          common-cpu-amd-pstate
          common-cpu-amd-zenpower
	  common-pc-ssd
        ];

        environment.systemPackages = [ pkgs.hello ];

        hardware = {
	  enableRedistributableFirmware = true;
	  keyboard.zsa.enable = true;
        };

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
    policies.to-mbainter =
      { host, user, lib, ... }:
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

    includes = [
      den.aspects.disko
      den.aspects.nix
      my.networking
      (den.batteries.vm-autologin "mbainter")
      den.aspects.tyr.policies.to-mbainter
    ];
  };
}
