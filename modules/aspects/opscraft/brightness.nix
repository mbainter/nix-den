{
  opscraft.brightness =
    { host, pkgs, ... }:
    let
      defaultBrightness = host.defaultBrightness or "60%";
    in
    {
      nixos = _: {
        systemd = {
          packages = with pkgs; [ brightnessctl ];

          services.reset-brightness = {
            description = "Set screen brightness to default level";
            serviceConfig = {
              Type = "oneshot";
              ExecStart = "${pkgs.brightnessctl}/bin/brightnessctl -c backlight set ${defaultBrightness}";
            };
          };
        };
      };
    };
}
