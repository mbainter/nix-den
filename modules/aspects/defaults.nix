{
  config,
  # deadnix: skip # enable <den/brackets> syntax for demo.
  __findFile ? __findFile,
  den,
  ...
}:
{
  # Lets also configure some defaults using aspects.
  # These are global static settings.
  den.default = {
  # These are functions that produce configs
    includes = [
      # Automatically set hostname
      <den/hostname>
  
      # Automatically create the user on host.
      <den/define-user>
  
      # Disable booting when running on CI on all NixOS hosts.
      (if config ? _module.args.CI then <opscraft/ci-no-boot> else { })
  
      # NOTE: be cautious when adding fully parametric functions to defaults.
      # defaults are included on EVERY host/user/home, and IF you are not careful
      # you could be duplicating config values. For example:
      #
      #  # This will append 42 into foo option for the {host} and for EVERY {host,user}
      #     ({ host, ... }: { nixos.foo = [ 42 ]; }) # DO-NOT-DO-THIS.
      #
      #  # Instead try to be explicit if a function is intended for ONLY { host }
      #     den.lib.perHost ({ host }: { nixos.foo = [ 42 ]; })
      #  # Or for { host, user } ONLY:
      #     den.lib.perUser ({ host, user }: { nixos.foo = [ 42 ]; })
      #  # Or for standalone homes ({ home }) ONLY:
      #     den.lib.perHome ({ home }: { homeManager.foo = [ 42 ]; })
    ];

    darwin =
      { ... }:
      {
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

          stateVersion = 6;
          nixpkgsRelease = "26.05";
          primaryUser = "mark.bainter";
        }; # system
      };

    nixos =
      { pkgs, lib, inputs, ... }:
      {
        boot.initrd.systemd.enable = true;

        documentation = {
	  doc.enable = false;
	  info.enable = false;
	};

	i18n = {
	  defaultLocale = "en_US.UTF-8";
	};

	time.timeZone = "America/Chicago";

	home-manager = {
	  useUserPackages = true;
	  useGlobalPkgs = true;
	};
	 
        nixpkgs.overlays = [
          (final: _prev: {
            unstable = import inputs.nixpkgs-unstable {
              inherit (final) config system;
            };
          })
        ];

    	system.stateVersion = "25.05";
      };

    homeManager = {
      programs.home-manager.enable = true;
      home.stateVersion = "25.05";
    };
  };
}
