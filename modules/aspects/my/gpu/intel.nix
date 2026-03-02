{
  my.gpu.intel =
    {
      provides.xserver.nixos = {
        services.xserver.videoDrivers = [
          "modesetting"
        ];
      };

      nixos = { pkgs, ... }: {

        environment.systemPackages = with pkgs; [
          clinfo
        ];

        hardware = {
          graphics.enable = true;
        };
      };
    };
}
