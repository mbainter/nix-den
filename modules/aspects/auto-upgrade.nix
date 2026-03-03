{
  my.auto-upgrade =
    { host, lib, pkgs, inputs, config, ... }:
    let
      inherit (config.networking) hostName;
      isClean = inputs.self ? rev;
    in
    {
      nixos =
      {
        system.autoUpgrade = {
          enable = isClean;
          dates = "hourly";
          flags = [
            "--refresh"
          ];
          flake = "git://github.com/mbainter/den-configs?ref=release-${hostName}";
          randomizedDelaySec = "45min";
        };

        # Only run if current config (self) is older than the new one.
        systemd.services.nixos-upgrade = lib.mkIf config.system.autoUpgrade.enable {
          serviceConfig.ExecCondition = lib.getExe (
            pkgs.writeShellScriptBin "check-date" ''
              lastModified() {
                nix flake metadata "$1" --refresh --json | ${lib.getExe pkgs.jq} '.lastModified'
              }
              test "$(lastModified "${config.system.autoUpgrade.flake}")"  -gt "$(lastModified "self")"
            ''
          );
        };
      };
    };
}
