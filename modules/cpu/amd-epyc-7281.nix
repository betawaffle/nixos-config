# AMD EPYC 7281
{ ... }:
{
  # Load the KVM module.
  boot.kernelModules = [ "kvm-amd" ];

  # Keep the microcode up to date.
  hardware.cpu.amd.updateMicrocode = true;

  # Allow nix builds to use all 32 threads.
  nix.buildCores = 32; # max parallelism of each build
  nix.maxJobs    = 16; # max concurrent builds

  # Tell nix it supports KVM and has lots of cores.
  nix.systemFeatures = [ "kvm" "big-parallel" ];
}
