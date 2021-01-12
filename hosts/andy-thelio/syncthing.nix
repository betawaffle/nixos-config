{ ... }:
{
  # For syncing files automatically between my devices.
  services.syncthing.enable = true;

  # FIXME: This seems is a hack, stop doing this!
  services.syncthing.user = "betawaffle";
}
