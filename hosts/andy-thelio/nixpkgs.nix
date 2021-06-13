{ flakes, lib, ... }:
{
  nix.binaryCachePublicKeys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
  ];

  nix.binaryCaches = [
    "https://cache.nixos.org"
    "https://nix-community.cachix.org"
    "https://nixpkgs-wayland.cachix.org"
  ];

  # Allow installing software with non-free licenses.
  nixpkgs.config.allowUnfree = true;

  # Overlay some packages.
  nixpkgs.overlays = [
    flakes.neovim-nightly-overlay.overlay
    flakes.nixpkgs-wayland.overlay
    flakes.rust-overlay.overlay

    flakes.nixos-config.overlay

    # flakes.nixos-config.overlays.blender
    # flakes.nixos-config.overlays.kea
    # flakes.nixos-config.overlays.neovim
    # flakes.nixos-config.overlays.zig
  ];
}
