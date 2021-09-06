# Tools for Configuring Logitech G600

{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    piper
  ];

  services.ratbagd.enable = true;
}
