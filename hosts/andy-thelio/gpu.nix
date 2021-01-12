{ ... }:
{
  # I've got an AMD Radeon RX 5700 XT.

  # Not sure if these are necessary, but I added them.
  hardware.opengl.driSupport = true;
  hardware.opengl.enable = true;

  # This applies to more than just xserver, they should probably rename the
  # option.
  services.xserver.videoDrivers = [ "amdgpu" ];
}
