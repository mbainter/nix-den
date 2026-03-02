{
  my.gpu.amd =
    { host, ... }:
    let
      enableAcceleration = host.enableGpuAcceleration or false;
    in
    {
      provides.xserver.nixos = {
        services.xserver.videoDrivers = [
          "modesetting"
        ];
      };

      nixos = { lib, pkgs, ... }: {

        environment.systemPackages = with pkgs; [
          lact
          clinfo
        ];

        hardware = {
          graphics.enable = true;
          amdgpu = {
            initrd.enable = true;
            opencl.enable = enableAcceleration;
          };
        };

        nixpkgs.config.rocmSupport = enableAcceleration;

        systemd = {
          packages = with pkgs; [ lact ];

          services.lactd = {
            description = "LACT GPU Control Daemon";
            wantedBy = [ "multi-user.target" ];
          };

          # Add HIP support
          tmpfiles.rules =
          let
            rocmEnv = pkgs.symlinkJoin {
              name = "rocm-combined";
              paths = with pkgs.rocmPackages; [
                rocblas
                hipblas
                clr
              ];
            };
          in lib.mkIf enableAcceleration [
            "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
          ];
        };
      };
    };
}
