{ flakes, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    stdenv.cc
    rust-bin.stable.latest.default
  ];

  nixpkgs.overlays = [
    flakes.rust-overlay.overlay
  ];
}
