{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    smartmontools
  ];

  # Enable S.M.A.R.T. Monitoring.
  services.smartd.enable = true;
}
