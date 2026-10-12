{ flakes, ... }:
{
  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
    "nickel.cachix.org-1:ABoCOGpTJbAum7U6c+04VbjvLxG9f0gJP5kYihRRdQs="
  ];

  nix.settings.substituters = [
    "https://cache.nixos.org"
    "https://nix-community.cachix.org"
    "https://nixpkgs-wayland.cachix.org"
    "https://nickel.cachix.org"
  ];

  # Allow installing software with non-free licenses.
  nixpkgs.config.allowUnfree = true;

  # Overlay some packages.
  nixpkgs.overlays = [
    # flakes.nixpkgs-wayland.overlay
    # flakes.fenix.overlay

    flakes.nixos-config.overlays.default
  ];
}
