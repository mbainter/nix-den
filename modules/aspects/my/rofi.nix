{
  my.rofi.homeManager =
    { lib, pkgs, ... }:
    {
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
    };
}
