{ den, ... }:
{
  den.aspects.vmacbook = {
    includes = [
      den.aspects.determinate
      # Other apple-specific aspects
      (den.provides.unfree [ "_1password-cli" "1password-cli" ])
    ];

    homeManager =
      { pkgs, ... }:
      {
        nixpkgs.config.allowUnfree = true;
        programs = {
          direnv.enable = true;
          home-manager.enable = true;
        };
      };

    # Apple-specific darwin configuration
    darwin =
      { lib, pkgs, ... }:
      {
        environment = {
          systemPackages = with pkgs; [
            ripgrep
	    unstable.devenv
	  ];

	  shells = [
            "${lib.getExe pkgs.bash}"
	    "/bin/bash"
	    "/bin/csh"
	    "/bin/dash"
	    "/bin/ksh"
	    "/bin/sh"
	    "/bin/tcsh"
	    "/bin/zsh"
	  ];
        };

	homebrew = {
          enable = true;

          onActivation = {
            autoUpdate = true;
            cleanup = "zap";
          };

	  brews = [
            "actionlint"
	    "archon"
	    "awscli"
	    "aws-sso-cli"
	    "direnv"
	    "eksctl"
	    "eks-node-viewer"
	    "fd"
	    "fzf"
	    "gh"
	    "github-mcp-server"
	    "jira-cli"
	    "jujutsu"
	    "just"
            "neovim"
	    "nono"
	    "openspec"
            "powershell"
	    "pi-coding-agent"
	    "podman"
	    "podman-tui"
	    "podman-compose"
	    "pyenv-virtualenv"
	    "python"
	    "ruff"
            "shellcheck"
	    "supabase"
	    "supabase-mcp-server"
	    "tenv"
	  ];

          casks = [
	    "amazon-workspaces"
	    "blackhole-2ch"
	    "cloudflare-warp"
	    "deskflow"
	    "ghostty"
	    "iterm2"
	    "keycastr"
	    "obs"
            "obsidian"
            "podman-desktop"
	    # "session-manager-plugin" # not signed, needs more sudo work to support
            "wezterm"
            "yubico-authenticator"
          ];

          caskArgs = {
            appdir = "~/Applications";
            require_sha = true;
          };

          # masApps = {
          #   "1Password for Safari" = 1569813296;
          #   "Yubico Authenticator" = 1497506650;
          # };

          taps = [
	    "aws/tap"
	    "coleam00/archon"
	    "deskflow/tap"
            "neovim/neovim"
            "nrlquaker/createzap"
          ];
        };

        nixpkgs.config.allowUnfree = true;

        system = {
          defaults = {
            NSGlobalDomain = {
              AppleIconAppearanceTheme = "RegularAutomatic";
              AppleInterfaceStyleSwitchesAutomatically = true;
              AppleScrollerPagingBehavior = true;
              AppleShowAllExtensions = true;
              AppleShowAllFiles = true;
              NSAutomaticCapitalizationEnabled = false;
              NSAutomaticInlinePredictionEnabled = false;
              NSAutomaticPeriodSubstitutionEnabled = false;
              NSAutomaticQuoteSubstitutionEnabled = false;
              NSAutomaticSpellingCorrectionEnabled = false;
              NSDocumentSaveNewDocumentsToCloud = false;
              NSNavPanelExpandedStateForSaveMode = true;
              NSWindowShouldDragOnGesture = true;
              "com.apple.keyboard.fnState" = true;
              "com.apple.swipescrolldirection" = false;
              "com.apple.trackpad.trackpadCornerClickBehavior" = 1;
            };
            SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;
            controlcenter = {
              BatteryShowPercentage = true;
              Bluetooth = true;
              Sound = true;
            };
            dock = {
              wvous-tl-corner = 1;
              wvous-tr-corner = 1;
              wvous-br-corner = 1;
              wvous-bl-corner = 13;
            };
            finder = {
              AppleShowAllExtensions = true;
              AppleShowAllFiles = true;
              FXRemoveOldTrashItems = true;
              _FXShowPosixPathInTitle = true;
            };
            loginwindow = {
              GuestEnabled = false;
              SHOWFULLNAME = true;
            };
            screencapture.type = "png";
            trackpad = {
              TrackpadCornerSecondaryClick = 2;
              TrackpadRightClick = true;
            };
          }; # system.defaults

          keyboard = {
            enableKeyMapping = true;
            remapCapsLockToEscape = true;
            swapLeftCommandAndLeftAlt = false;
            swapLeftCtrlAndFn = false;
          };

          nixpkgsRelease = "25.11";
          primaryUser = "mark.bainter";
        }; # system
      };

    # <host>.provides.<user>, via opscraft/routes.nix
    provides."mark.bainter" =
      { user, pkgs, ... }:
      {
        homeManager = 
	      {
          users.users."mark.bainter".shell = pkgs.bashInteractive;
        	programs.zoxide = {
            enable = user.name == "mark.bainter";
          };
        };

        # FIXME: condition this on shell
        enableBashIntegration = true;
        options = [
          "--cmd cd" #replace cd with z and zi (via cdi)
        ];
      };
  };
}
