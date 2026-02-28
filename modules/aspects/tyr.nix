{
  den.aspects.tyr = {
    # tyr host provides some home-manager defaults to its users.
    homeManager.programs.direnv.enable = true;

    # NixOS configuration for tyr.
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.hello ];
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
