{ den, opscraft, my, __findFile, ... }:
{
  # Work User
  den.aspects."mark.bainter" = {

    # mark.bainter can include other aspects.
    # For small, private one-shot aspects, use let-bindings like here.
    # for more complex or re-usable ones, define on their own modules,
    # as part of any aspect-subtree.
    includes = [
      <den/primary-user>
      (<den/user-shell> "bash") # default user shell
      <my/gpg>
      <my/git>
      (den.provides.unfree [ "1password-cli" "_1password-cli" ])
      den.aspects.bainter
      den.aspects."mark.bainter".policies.to-vmacbook
    ];

    # mark.bainter configures NixOS hosts it lives on.
    nixos =
      { pkgs, ... }:
      {
        users.users."mark.bainter".packages = with pkgs; [
          vim
          ripgrep
        ];
      };

    # mark.bainter home-manager.
    homeManager =
      { pkgs, ... }:
      {
        programs = {
          home-manager.enable = true;
          bash = {
            enable = true;
            enableCompletion = true;
            historySize = 10000;
            historyFile = "$HOME/.bash_history";
            historyFileSize = 100000;
            historyControl = ["erasedups" "ignoreboth"];
            historyIgnore = ["ls" "cd" "exit" "pwd"];

            shellOptions = [
              "histappend"
              "checkwinsize"
            ];

            initExtra=''
              # make less more friendly for non-text input files, see lesspipe(1)
              [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

              # set a fancy prompt (non-color, unless we know we "want" color)
              case "$TERM" in
                  wezterm|xterm-color|*-256color) color_prompt=yes;;
              esac
            '';

            profileExtra = ''
              export BASH_SILENCE_DEPRECATION_WARNING="1"
              # include local profile if it exists
              [[ -f ~/.bash_profile.local ]] && . ~/.bash_profile.local
            '';

            bashrcExtra = ''
              # include local bashrc if it exists
              [[ -f ~/.bashrc.local ]] && . ~/.bashrc.local
            '';
          };
          gh = {
            enable = true;
          };
          starship = {
            enable = true;
            enableBashIntegration = true;
          };
        };
        home = {
          sessionPath = [ "$HOME/.local/bin" ];
          sessionVariables = {
            BASH_SILENCE_DEPRECATION_WARNING = "1";
          };
          packages = with pkgs; [ htop ];

          shell.enableBashIntegration = true;
          shellAliases = {
            vim = "nvim";
          };
        };
      };

    # <user>.policies.<name>, aspect-included policy
    # Delivers NixOS config to the host (cross-scope via policy.provide).
    policies.to-vmacbook =
      { host, user, lib, ... }:
      lib.optional (host.name == "vmacbook") (
        den.lib.policy.provide {
          class = "nixos";
          module.programs.nh.enable = true;
        }
      );
  };

  # This is a context-aware aspect, that emits configurations
  # **anytime** at least the `user` data is in context.
  # read more at https://den.denful.dev/explanation/parametric/
  den.aspects.bainter =
    { user, ... }:
    {
      nixos.users.users.${user.userName} = {
        description = "Mark Bainter";
      };
    };

  #den.aspects.setHost =
  #  { host, ... }:
  #  {
  #    networking.hostName = host.hostName;
  #    # networking.hostName = "MBainter1225m";
  #  };
}
