{
  my.zoxide = {
    homeManager =
      {
        programs.zoxide = {
          enable = true;
          enableBashIntegration = true;
          options = [
            "--cmd cd" #replace cd with z and zi (via cdi)
          ];
        };
      };
  };
}
