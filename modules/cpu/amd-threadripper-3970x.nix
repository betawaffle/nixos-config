# AMD Ryzen Threadripper 3970X
{ ... }:
{
  # Load the KVM module.
  boot.kernelModules = [ "kvm-amd" ];

  # Keep the microcode up to date.
  hardware.cpu.amd.updateMicrocode = true;

  # Allow nix builds to use all 64 threads.
  nix.settings.cores    = 64; # max parallelism of each build
  nix.settings.max-jobs = 32; # max concurrent builds

  # Tell nix it supports KVM and has lots of cores.
  nix.settings.system-features = [ "kvm" "big-parallel" ];
}
