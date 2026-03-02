{
  opscraft.i3.nixos =
    { lib, pkgs, config, ... }:
    {
      # FIXME: do I still need this?
      # environment = {
      #   pathsToLink = ["/libexec"];
      # };

      programs = {
        seahorse.enable = true;
      };

      security.pam.services = {
        i3lock.enable = true;
        #lightdm.enableGnomeKeyring = true;
        login.enableGnomeKeyring = true;
      };

      # https://gist.github.com/nat-418/1101881371c9a7b419ba5f944a7118b0
      services = {
        autorandr = {
          enable = true;
        };

        displayManager = {
          # lightdm.enable = true;
          # lemurs = {
          #   enable = true;
          # };
          ly = {
            enable = true;
            x11Support = true;
          };
          autoLogin.enable = lib.mkDefault false;
          defaultSession = "i3";
        };

        dbus.packages = [ pkgs.gnome-keyring pkgs.gcr ];
        gnome.gnome-keyring.enable = true;

        xserver = {
          enable = true;
          xkb.layout = "us";

          displayManager.session = [
            {
              manage = "desktop";
              name = "i3";
              start = ''
                exec ${pkgs.i3}/bin/i3
              '';
            }
          ];

          desktopManager = {
            runXdgAutostartIfNone = false;
            xterm.enable = false;
          };

          windowManager.i3 = {
            enable = true;

            extraPackages = with pkgs; [
              brightnessctl
              dex
              dmenu
              flameshot
              i3blocks
              i3lock-fancy
              i3status-rust
              networkmanager_dmenu
              nitrogen
              xclip
              xdg-utils
              xdotool
              xsel
              xss-lock
              xidlehook
              xorg.xdpyinfo
              xev
              xrandr
              xorg.xrdb
              xset
            ];

            extraSessionCommands = ''
              eval $(gnome-keyring-daemon --daemonize)
            '';
          };
        };
      };

      xdg.portal = {
        enable = true;

        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
        ];

        configPackages = config.xdg.portal.extraPortals ++ (with pkgs; [
          gnome-keyring
        ]);
      };
    };

  opscraft.i3.homeManager =
    { config, lib, pkgs, ... }:
    let
      mod = config.xsession.windowManager.i3.config.modifier;
      exec = "exec --no-startup-id";
    in
    {
      xdg.configFile."i3status-rust/config.toml".source = ./conf/i3status-config.toml;

      home.packages = builtins.attrValues {
        inherit (pkgs)
          rofi-menugen
          rofi-systemd
          wezterm;
      };

      programs.rofi = {
        enable = true;
        font = "Noto Sans 14";

        pass = {
          enable = true;
          package = pkgs.gopass;
        };

        terminal = "${pkgs.wezterm}/bin/wezterm";

        plugins = with pkgs; [
          rofi-calc
          rofi-file-browser
          rofi-emoji
          rofi-network-manager
          rofi-pass
          rofi-obsidian
          # rofi-systemd
          rofi-power-menu
          pinentry-rofi
        ];

        modes = [
          "combi"
          "run"
          "ssh"
          "emoji"
          "calc"
          "drun"
          "window"
          "filebrowser"
          {
            name = "obsidian";
            path = lib.getExe pkgs.rofi-obsidian;
          }
          # Needs root
          # {
          #   name = "systemd";
          #   path = lib.getExe pkgs.rofi-systemd;
          #  }
          {
            name = "power-menu";
            path = lib.getExe pkgs.rofi-power-menu;
          }
          {
            name = "network-manager";
            path = lib.getExe pkgs.rofi-network-manager;
          }
        ];

        extraConfig = {
          dpi = 0;

          combi-modi = "window,drun,obsidian";
          show-icons = true;
        };
      };

      xsession = {
        enable = true;
        windowManager.i3 = {
          enable = true;
          config = {
            modifier = "Mod4";

            bars = [
              {
                position = "top";
                fonts = {
                  names = [
                    "pango:DejaVu Sans Mono"
                    "Font Awesome 6 Free"
                  ];
                };

                statusCommand = "${lib.getExe pkgs.i3status-rust} ~/.config/i3status-rust/config.toml";
                colors = {
                  separator          = "#4b5262";
                  background         = "#161616";
                  statusline         = "#161616";
                  focusedWorkspace  = {
                    border = "#161616";
                    background = "#ee5396";
                    text = "#161616";
                  };
                  activeWorkspace   = {
                    border = "#161616";
                    background = "#ee5396";
                    text = "#161616";
                  };
                  inactiveWorkspace = {
                    border = "#161616";
                    background = "#161616";
                    text = "#dde1e6";
                  };
                  urgentWorkspace = {
                    border = "#161616";
                    background = "#ebcb8b";
                    text = "#2f343f";
                  };
                };
              }
            ];

            fonts = {
              names = [
                "pango:monospace"
              ];
              size = 8.0;
            };

            keybindings = lib.mkOptionDefault {
              "${mod}+d" = ''${exec} rofi -modi "drun#window" -show drun -theme ~/.config/rofi/config.rasi'';
              "${mod}+r" = ''${exec} rofi -modi "run#window" -show run -theme ~/.config/rofi/config.rasi'';
              "${mod}+w" = ''${exec} rofi -modi "window" -show window -theme ~/.config/rofi/config.rasi'';
              "${mod}+period" = ''${exec} rofi -modi emoji -show emoji'';
            };
          };
          extraConfig = ''
            # Move to scratchpd
            bindsym $mod+Shift+u move scratchpad
            # Show scratchpad
            bindsym $mod+u scratchpad show

            for_window [window_role="About"] floating enable
            for_window [window_role="Organizer"] floating enable
            for_window [window_role="Preferences"] floating enable
            for_window [window_role="bubble"] floating enable
            for_window [window_role="page-info"] floating enable
            for_window [window_role="pop-up"] floating enable
            for_window [window_role="task_dialog"] floating enable
            for_window [window_role="toolbox"] floating enable
            for_window [window_role="webconsole"] floating enable
            for_window [window_type="dialog"] floating enable
            for_window [window_type="menu"] floating enable
            for_window [class="zoom"] floating enable, sticky enable
            for_window [class="zoom" title="settings"] floating enable, sticky enable
            for_window [class="zoom" title="zoom meeting"] floating enable, sticky enable
          '';
        };
        scriptPath = ".xsession";
      };
    };
}
