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
      vmacbook = inputs.self.darwinConfigurations.vmacbook.config;
      tyr = inputs.self.nixosConfigurations.tyr.config;
      mbainter-at-tyr = tyr.home-manager.users.mbainter;
      mbainter-at-vmacbook = vmacbook.home-manager.users."mark.bainter";
      vmBuilds = !pkgs.stdenvNoCC.isLinux || builtins.pathExists (self'.packages.vm + "/bin/vm");
      tyrBuilds = !pkgs.stdenvNoCC.isLinux || builtins.pathExists (tyr.system.build.toplevel);
      vmacbookBuilds = !pkgs.stdenvNoCC.isDarwin || builtins.pathExists (vmacbook.system.build.toplevel);
    in
    {
      # checks."tyr builds" = checkCond "tyr-builds" tyrBuilds;
      checks."vmacbook builds" = checkCond "vmacbook-builds" vmacbookBuilds;
      # checks."vm builds" = checkCond "vm-builds" vmBuilds;

      checks."mbainter enabled tyr nh" = checkCond "mbainter.tyr" tyr.programs.nh.enable;
      checks."mark.bainter enabled vmacbook nh" = checkCond "mark.bainter.vmacbook" vmacbook.programs.nh.enable;
    };
}
