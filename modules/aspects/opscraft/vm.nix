{ opscraft, ... }:
{
  opscraft.vm.provides = {
    gui.includes = [
      opscraft.vm
      opscraft.vm-bootable.gui
      opscraft.i3
    ];

    tui.includes = [
      opscraft.vm
      opscraft.vm-bootable.tui
    ];
  };
}
