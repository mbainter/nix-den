{ den, opscraft, ... }:
{
  # Work User
  den.aspects."mark.bainter" = {

    # mark.bainter can include other aspects.
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
        (<den/user-shell> "bash") # default user shell
      ];

    # mark.bainter configures NixOS hosts it lives on.
    nixos =
      { pkgs, ... }:
      {
        users.users."mark.bainter".packages = [ 
          pkgs.vim 
          pkgs.ripgrep
        ];
      };

    # mark.bainter home-manager.
    homeManager =
      { pkgs, ... }:
      {
        programs = {
          home-manager.enable = true;
          gh = {
            enable = true;
          };
        };
        home = {
          sessionPath = [ "$HOME/.local/bin" ];
          packages = [ pkgs.htop pkgs.neovim ];
        };
      };

    # <user>.provides.<host>, via opscraft/routes.nix
    provides.vmacbook =
      { host, ... }:
      {
        nixos.programs.nh.enable = host.name == "vmacbook";
      };
  };

  # This is a context-aware aspect, that emits configurations
  # **anytime** at least the `user` data is in context.
  # read more at https://vic.github.io/den/context-aware.html
  den.aspects.bainter =
    { user, ... }:
    {
      nixos.users.users.${user.userName} = {
        description = "Mark Bainter";
      };
    };

  den.aspects.setHost =
    { host, ... }:
    {
      # networking.hostName = host.hostName;
      networking.hostName = "MBainter1225m";
    };
}
