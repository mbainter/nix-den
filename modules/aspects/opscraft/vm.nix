{ opscraft, ... }:
{
  opscraft.vm.provides = {
    gui.includes = [
      opscraft.vm
      opscraft.vm-bootable._.gui
      opscraft.i3
    ];

    tui.includes = [
      opscraft.vm
      opscraft.vm-bootable._.tui
    ];
  };
}
