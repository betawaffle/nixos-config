{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    river-updated
  ];

  xdg.portal.wlr.enable = true;
}
