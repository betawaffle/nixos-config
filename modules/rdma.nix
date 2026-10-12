{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    (rdma-core.overrideAttrs (old: old // { separateDebugInfo = true; dontStrip = true; }))
  ];
}
