{ den, opscraft, ... }:
{
  den.aspects.mbainter = {

    # mbainter can include other aspects.
    # For small, private one-shot aspects, use let-bindings like here.
    # for more complex or re-usable ones, define on their own modules,
    # as part of any aspect-subtree.
    includes =
      let
        # hack for nixf linter to keep findFile :/
        unused = den.lib.take.unused __findFile;
        __findFile = unused den.lib.__findFile;

        # customEmacs.homeManager =
        #   { pkgs, ... }:
        #   {
        #     programs.emacs.enable = true;
        #     programs.emacs.package = pkgs.emacs30-nox;
        #  };
      in
      [
        # from the aspect tree, bainter example is defined bellow
        den.aspects.bainter
        den.aspects.setHost
        # from the `opscraft` namespace.
        # opscraft.autologin
        # den included batteries that provide common configs.
        <den/primary-user> # mbainter is admin always.
        (<den/user-shell> "bash") # default user shell
      ];

    # mbainter configures NixOS hosts it lives on.
    nixos =
      { pkgs, ... }:
      {
        users.users.mbainter.packages = [ pkgs.vim ];
      };

    # mbainter home-manager.
    homeManager =
      { pkgs, ... }:
      {
        home.packages = [ pkgs.htop ];
      };

    # <user>.provides.<host>, via opscraft/routes.nix
    provides.tyr =
      { host, ... }:
      {
        nixos.programs.nh.enable = host.name == "tyr";
      };

    provides.vidar =
      { host, ... }:
      {
        nixos.programs.nh.enable = host.name == "vidar";
      };
  };

  # This is a context-aware aspect, that emits configurations
  # **anytime** at least the `user` data is in context.
  # read more at https://vic.github.io/den/context-aware.html
  den.aspects.bainter =
    { user, ... }:
    {
      nixos.users.users.${user.userName} = {
        initialPassword = "changeme";
        description = "Mark Bainter";
      };
    };

  den.aspects.setHost =
    { host, ... }:
    {
      networking.hostName = host.hostName;
    };
}
