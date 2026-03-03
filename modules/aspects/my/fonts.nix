{
  my.fonts = 
    { pkgs, ... }:
    {
      nixos = {
        fonts = {
          packages = with pkgs; [
            material-design-icons
            noto-fonts
            noto-fonts-color-emoji
            nerd-fonts.fira-code
            nerd-fonts.jetbrains-mono
          ];

          fontconfig = {
            enable = true;
            antialias = true;

            hinting = {
              enable = false;
              autohint = false;
              style = "none";
            };

            subpixel = {
              lcdfilter = "none";
              rgba = "none";
            };

            defaultFonts = {
              serif = ["Noto Serif" "Noto Color Emoji"];
              sansSerif = ["Noto Sans" "Noto Color Emoji"];
              monospace = ["JetBrainsMono Nerd Font" "Noto Color Emoji"];
              emoji = ["Noto Color Emoji"];
            };
          };
        };
      };
    };
}
