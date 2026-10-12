{ config, flakes, pkgs, ... }:
{
  imports = [
    flakes.agenix.nixosModule
  ];

  environment.systemPackages = [
    flakes.agenix.defaultPackage.${config.nixpkgs.system}
  ];
}
