{ pkgs, ... }:
{
  # Enable the nix command, flakes, and recursive nix.
  nix.extraOptions = ''
    experimental-features = nix-command flakes recursive-nix
  '';

  # Use the nixUnstable package.
  nix.package = pkgs.nixUnstable;

  # Mark our system as supporting recursive nix.
  nix.systemFeatures = [ "recursive-nix" ];
}
