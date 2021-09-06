{ config, flakes, lib, ... }:
{
  imports = [
    flakes.home-manager.nixosModules.home-manager
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
}
