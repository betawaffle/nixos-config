{ config, flakes, lib, ... }:
{
  # Reduce space used by the nix store automatically.
  nix.settings.auto-optimise-store = true;

  # Run the nix store optimizer periodically.
  nix.optimise.automatic = true;

  # Clean up unused stuff automatically.
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 7d";

  # Needed for non-flakes stuff.
  nix.nixPath = lib.mkForce [
    "nixpkgs=${flakes.nixpkgs}"
    "kernel=${config.boot.kernelPackages.kernel}"
  ];
}
