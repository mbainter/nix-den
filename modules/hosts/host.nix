{
  # Host schema definitions
  den.schema.host =
    { lib, ... }:
    {
      options = {
        isLaptop = lib.mkEnableOption {
          default = false;
	  description = "Is this host a laptop?";
        };
        isHeadless = lib.mkEnableOption {
          default = false;
	  description = "Does this host typically run without an attached display?";
        };
	defaultBrightness = lib.mkOption {
	  type = lib.types.strMatching "^([0-9]{1,2}|100)%$"
	  default = "80%";
	  description = "Initial backlight brightness at boot expressed as a percentage";
	};
      };
    };
}
