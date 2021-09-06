{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    binutils
    stdenv.cc
    rustup
  ];
}
