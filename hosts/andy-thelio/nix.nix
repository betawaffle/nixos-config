{ lib, ... }:
{
  # Reduce space used by the nix store automatically.
  nix.autoOptimiseStore = true;

  # Run the nix store optimizer periodically.
  nix.optimise.automatic = true;

  # Clean up unused stuff automatically.
  nix.gc.automatic = true;

  # Since we're using a flake, remove everything from NIX_PATH.
  #
  # XXX: Not certain the mkForce is necessary.
  nix.nixPath = lib.mkForce [];
}
