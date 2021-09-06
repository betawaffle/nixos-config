# AMD Ryzen Threadripper 3970X
{ ... }:
{
  # Load the KVM module.
  boot.kernelModules = [ "kvm-amd" ];

  # Keep the microcode up to date.
  hardware.cpu.amd.updateMicrocode = true;

  # Allow nix builds to use all 64 threads.
  nix.buildCores = 64; # max parallelism of each build
  nix.maxJobs    = 32; # max concurrent builds

  # Tell nix it supports KVM and has lots of cores.
  nix.systemFeatures = [ "kvm" "big-parallel" ];
}
