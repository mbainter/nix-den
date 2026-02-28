# Some CI checks to ensure this template always works.
# Feel free to adapt or remove when this repo is yours.
{ inputs, ... }:
{
  perSystem =
    {
      pkgs,
      self',
      lib,
      ...
    }:
    let
      checkCond = name: cond: pkgs.runCommandLocal name { } (if cond then "touch $out" else "");
      apple = inputs.self.darwinConfigurations.apple.config;
      tyr = inputs.self.nixosConfigurations.tyr.config;
      mbainter-at-tyr = tyr.home-manager.users.mbainter;
      vmBuilds = !pkgs.stdenvNoCC.isLinux || builtins.pathExists (self'.packages.vm + "/bin/vm");
      tyrBuilds = !pkgs.stdenvNoCC.isLinux || builtins.pathExists (tyr.system.build.toplevel);
      appleBuilds = !pkgs.stdenvNoCC.isDarwin || builtins.pathExists (apple.system.build.toplevel);
    in
    {
      # checks."tyr builds" = checkCond "tyr-builds" tyrBuilds;
      # checks."apple builds" = checkCond "apple-builds" appleBuilds;
      # checks."vm builds" = checkCond "vm-builds" vmBuilds;

      checks."mbainter enabled tyr nh" = checkCond "mbainter.provides.tyr" tyr.programs.nh.enable;
      checks."tyr enabled mbainter helix" =
        checkCond "tyr.provides.mbainter" mbainter-at-tyr.programs.helix.enable;
    };
}
