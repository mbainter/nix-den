{
  my.deskflow =
    { pkgs, ... }:
    {
      networking.firewall.allowedTCPPorts = [ 24800 ];
    
      environment.systemPackages = with pkgs; [
        deskflow
      ];
    };
}
