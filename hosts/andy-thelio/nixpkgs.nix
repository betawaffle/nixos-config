{ flakes, lib, ... }:
{
  nix.binaryCachePublicKeys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  ];

  nix.binaryCaches = [
    "https://cache.nixos.org"
  ];

  # Allow installing software with non-free licenses.
  nixpkgs.config.allowUnfree = true;

  # Overlay some packages.
  nixpkgs.overlays = [
    # flakes.nixos-config.overlay

    # flakes.nixos-config.overlays.blender
    # flakes.nixos-config.overlays.kea
    # flakes.nixos-config.overlays.neovim
    # flakes.nixos-config.overlays.zig
  ];
}
