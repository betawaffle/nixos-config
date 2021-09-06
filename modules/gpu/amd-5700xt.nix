# AMD Radeon RX 5700 XT
{ pkgs, ... }:
{
  # Make the kernel use the correct driver early.
  boot.initrd.kernelModules = [ "amdgpu" ];

  environment.systemPackages = with pkgs; [
    clinfo # OpenCL
  ];

  # Not sure if these are necessary, but I added them.
  hardware.opengl.driSupport = true;
  hardware.opengl.enable = true;
  hardware.opengl.extraPackages = with pkgs; [
    rocm-opencl-icd
    rocm-opencl-runtime
  ];

  # This applies to more than just xserver, they should probably rename the
  # option.
  services.xserver.videoDrivers = [ "amdgpu" ];
}
