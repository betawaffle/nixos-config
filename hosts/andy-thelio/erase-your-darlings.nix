{ lib, ... }:
{
  # Rollback root filesystem to a blank snapshot, which must exist for this to
  # work.
  #
  # TODO: Make this more generic so it can be shared with other systems.
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r rpool/system/root@blank
  '';

  # Store SSH host keys in a persistent location.
  services.openssh.hostKeys = [
    {
      path = "/var/lib/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }
    {
      path = "/var/lib/ssh/ssh_host_rsa_key";
      type = "rsa";
      bits = 4096;
    }
  ];
}
