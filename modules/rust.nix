{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # llvmPackages_latest.llvm
    # llvmPackages_latest.bintools
    # llvmPackages_latest.lld

    stdenv.cc
    bintools

    rustup
    rust-analyzer
    # rust-analyzer-nightly
  ];
}
