{ flakes, ... }:
{
  nix.binaryCachePublicKeys = [
    "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
  ];

  nix.binaryCaches = [
    "https://nixpkgs-wayland.cachix.org"
  ];

  nixpkgs.overlays = [
    flakes.nixpkgs-wayland.overlay
  ];
}
