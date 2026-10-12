{ lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    klayout
    openroad
  ];
}
