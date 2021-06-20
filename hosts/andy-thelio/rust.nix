{ flakes, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    binutils
    stdenv.cc

    # rust-bin.stable.latest.default
    # rust-bin.nightly.latest.default

    rustup
  ];
}
