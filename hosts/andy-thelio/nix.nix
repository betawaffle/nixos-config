{ lib, ... }:
{
  # Reduce space used by the nix store automatically.
  nix.autoOptimiseStore = true;

  # Run the nix store optimizer periodically.
  nix.optimise.automatic = true;

  # Clean up unused stuff automatically.
  nix.gc.automatic = true;

  # Needed for ngrok non-flakes stuff.
  nix.nixPath = lib.mkForce [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos-unstable"
  ];
}
