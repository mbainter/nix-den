{
  my.apps.keypass =
    { user, pkgs, ... }:
    {
      homeManager =
      {
        services.kbfs = {
          enable = true;
          mountPoint = "%t/kbfs";
          extraFlags = [ "-label %u" ];
        };

        services.keybase.enable = true;

      };
    };
}
