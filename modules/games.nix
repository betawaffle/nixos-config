{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    dialog # Not a game, but needed for minecraft?
    minecraft
  ];

  # Steam
  programs.steam.enable = true;
}
