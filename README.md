# Ladybird Docker Dev

Sets up Docker container, bind mounts and patches Ladybird scripts to allow
both building and running the [Ladybird web browser](https://ladybird.org)
easily from any Linux distro, in a more reproducible and hermetic manner.

## Why not just Nix-ify it? You already have a flake in here!

That would be nice, but I don't know nearly enough Nix and cmake to convert
the Ladybird build process to Nix, nor do I know how to take the Ladybird
package definition from nixpkgs and convert it to a suitable dev environment.

From the looks of it, it seems like the nixpkgs version patches a bunch of stuff
to Ladybird to build it, which is fine (after all most Linux distros have some
patches for programs for their own purposes), but for a dev environment it would
be nice to start out from *exactly* the same code as everyone else, without any
alterations.

The Docker based flow here only really requires a small modification to a support
script, which is unlikely to be touched by most changes and is also restored back
when the container is destroyed.

As for the flake, it installs stuff like `just`, `gdb`, and `clangd`, which is nice
for a) running the container script anywhere I'd like, b) debugging, and c) LSPing
my way through the source code.
