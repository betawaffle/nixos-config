{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    zig # zig-master
    zls-override
  ];
}
