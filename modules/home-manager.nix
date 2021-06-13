{ config, flakes, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.features.home-manager;
in

{
  imports = [
    flakes.home-manager.nixosModules.home-manager
  ];

  options.features.home-manager = {
    enable = mkEnableOption "Home Manager";
  };

  config = mkIf cfg.enable {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;

    # home-manager.users.jdoe = import ./home.nix;
  };
}
