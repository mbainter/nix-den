{
  opscraft.i3.nixos =
    { lib, pkgs, config, ... }:
    {
      programs.seahorse.enable = true;
      security.pam.services = {
        i3lock.enable = true;
        lightdm.enableGnomeKeyring = true;
      };

      # https://gist.github.com/nat-418/1101881371c9a7b419ba5f944a7118b0
      services = {
        autorandr = {
          enable = true;
        };

        dbus.packages = [ pkgs.gnome-keyring pkgs.gcr ];
        gnome.gnome-keyring.enable = true;

        xserver = {
          enable = true;
          desktopManager = {
            xterm.enable = false;
          };

          windowManager.i3 = {
            enable = true;
            package = pkgs.i3;

            extraPackages = with pkgs; [
              dmenu
              networkmanager_dmenu
              i3blocks
              i3lock-fancy
              i3status-rust
              dex
              nitrogen
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
}
