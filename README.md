# Examples

This template provides some basic examples of how to use Den features.
However, you will learn more by reading templates/ci which tests all of Den.

Steps you can follow after cloning this template:

- Be sure to read the [den documentation](https://vic.github.io/den)

- Update den input.

```console
nix flake update den
```

- Run checks to test everything works.

```console
nix flake check
```

- Read [modules/den.nix](modules/den.nix) where hosts and homes definitions are for this example.

- Read [modules/namespace.nix](modules/namespace.nix) where a new `opscraft` (an example) aspects namespace is created.

- Read [modules/aspects/tyr.nix](modules/aspects/tyr.nix) where the `tyr` host is configured.

- Read [modules/aspects/mbainter.nix](modules/aspects/mbainter.nix) where the `mbainter` user is configured.

- Run the VM.

```console
nix run .#vm
```

- Edit and run VM loop.

Feel free to add more aspects, organize things to your liking.
