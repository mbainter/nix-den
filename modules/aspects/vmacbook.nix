{ den, ... }:
{
  den.aspects.vmacbook = {
    includes = [
      den.aspects.determinate
      den.aspects.mbainter     # Include user configuration
      # Other apple-specific aspects
    ];

    # Apple-specific darwin configuration
    darwin =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          # macOS-specific packages
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
