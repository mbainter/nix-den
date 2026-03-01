{ inputs, den, ... }:
{
  imports = [ 
    # Modules are generic enough to be useful to others
    (inputs.den.namespace "opscraft" true) 
    # Modules that are specific to me
    (inputs.den.namespace "my" false)
  ];

  # this line enables den angle brackets syntax in modules.
  _module.args.__findFile = den.lib.__findFile;
}
