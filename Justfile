default:
  @just --list


[group('darwin')]
rebuild ACTION="switch" TARGET="vmacbook" *FLAGS:
  sudo darwin-rebuild {{ACTION}} --flake .#{{TARGET}}

[group('darwin')]
rebuild-debug ACTION="switch" TARGET="vmacbook":
  (rebuild {{ACTION}} {{TARGET}} --show-trace --verbose 

[group('darwin')]
rboot TARGET="vmacbook":
  (rebuild boot {{TARGET}})

[group('nix')]
update *INPUT:
  nix flake update {{INPUT}}

[group('nix')]
history:
  nix profile history --profile /nix/var/nix/profiles/system


# Delete entries older than 7d
[group('nix')]
gc:
  # System
  sudo nix-collect-garbage --delete-older-than 7d
  # Home-Manager, etc
  nix-collect-garbage --delete-older-than 7d
