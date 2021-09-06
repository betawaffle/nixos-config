{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    bluez
  ];

  # Enable bluetooth.
  hardware.bluetooth.enable = true;

  # NixOS allows either a lightweight build (default) or full build of PulseAudio to be installed.
  # Only the full build has Bluetooth support, so it must be selected here.
  hardware.pulseaudio.package = pkgs.pulseaudioFull;

  # Bluetooth
  services.blueman.enable = true;
}
