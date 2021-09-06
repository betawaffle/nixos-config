{ pkgs, ... }:
{
  environment.variables.EDITOR = "nvim";

  environment.systemPackages = with pkgs; [
    neovim
  ];
}
