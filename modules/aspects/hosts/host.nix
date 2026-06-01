{
  # Host schema definitions
  den.schema.host =
    { lib, ... }:
    {
      options.isLaptop = lib.mkEnableOption {
        default = false;
	description = "Is this host a laptop?";
      };
      options.isHeadless = lib.mkEnableOption {
        default = false;
	description = "Does this host typically run without an attached display?";
      };
    };
}
