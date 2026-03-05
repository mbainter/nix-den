{ inputs, ... }:
{
  flake-file.inputs.nixvim.url = "github:nix-community/nixvim";
  
  my.nixvim =
    {
      homeManager =
        { pkgs, ... }:
        {
          imports = [ inputs.nixvim.homeModules.nixvim ];
          enable = true;
        };
    };
}
