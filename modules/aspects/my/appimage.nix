{
  my.appimage =
    {
      nixos = {
        # FIXME: This should probably go in desktop or defaults
        programs.appimage = {
          enable = true;
          binfmt = true;
        };
      };
    };
}
