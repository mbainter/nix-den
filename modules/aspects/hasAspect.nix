# Two complementary tools for two different jobs:
#
#   - `entity.hasAspect` READS structure at query time from inside
#     class-config module bodies (`nixos = ...`, `homeManager = ...`).
#     Cycle-safe because the body runs at evalModules time, long after
#     the aspect tree has been resolved and frozen.
#
#   - `oneOfAspects` (and friends in `nix/lib/aspects/adapters.nix`)
#     WRITE structure at adapter time with full structural visibility.
#     The right tool for "prefer A over B when both are present" and
#     other tree-shape decisions.
#
{ den, lib, ... }: { }
