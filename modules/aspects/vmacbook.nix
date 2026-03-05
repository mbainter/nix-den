{ den, ... }:
{
  den.aspects.vmacbook = {
    includes = [
      den.aspects.determinate
      # Other apple-specific aspects
    ];

    homeManager =
    {
      programs = {
        direnv.enable = true;
	home-manager.enable = true;
      };
    };

    # Apple-specific darwin configuration
    darwin =
      { pkgs, ... }:
      {
        environment = {
          systemPackages = with pkgs; [
            ripgrep
          ];
        };

	homebrew = {
          enable = true;

          onActivation = {
            autoUpdate = true;
            cleanup = "zap";
          };

	  brews = [];

          casks = [
            "obsidian"
            "podman-desktop"
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
            "neovim/neovim"
            "nrlquaker/createzap"
          ];
        };

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
              wvous-tl-corner = 6;
              wvous-tr-corner = 6;
              wvous-br-corner = 10;
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
      { user, ... }:
      {
        homeManager.programs.zoxide = {
          enable = user.name == "mark.bainter";
        };

        # FIXME: condition this on shell
        enableBashIntegration = true;
        options = [
          "--cmd cd" #replace cd with z and zi (via cdi)
        ];
      };
  };
}
