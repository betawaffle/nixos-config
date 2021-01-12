{ ... }:
{
  # Expose the API beyond localhost.
  # services.ipfs.apiAddress = "/ip4/192.168.2.30/tcp/5001";

  # Don't initialize the repo with help files.
  services.ipfs.emptyRepo = true;

  # Enable IPFS.
  services.ipfs.enable = true;

  # Enable automatic garbage collection.
  services.ipfs.enableGC = true;

  # Expose the gateway beyond localhost.
  # services.ipfs.gatewayAddress = "/ip4/192.168.2.30/tcp/8080";

  # Use socket activation.
  services.ipfs.startWhenNeeded = true;
}
