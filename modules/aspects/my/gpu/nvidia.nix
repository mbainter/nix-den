{
  my.gpu.nvidia =
    {
      provides.xserver.nixos = {
        services.xserver.videoDrivers = [
          "nvidia"
        ];
      };

      nixos = { inputs, pkgs, ... }: {
        imports = [
          inputs.hardware.nixosModules.common-gpu-nvidia
        ];

        environment.systemPackages = with pkgs; [
          clinfo
        ];

        hardware = {
          graphics.enable = true;
          nvidia = {
            powerManagement.enable = false;
            modesetting.enable = true;

            prime = {
              offload.enable = false;
              sync.enable = true;
            };
          };
        };
      };
    };
}
