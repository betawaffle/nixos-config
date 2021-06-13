{ config, pkgs, ... }:
{
  imports = [
    ./cpu.nix
    ./efi.nix
    ./fonts.nix
    ./fs.nix
    # ./ipfs.nix
    ./linux.nix
    ./misc.nix
    ./network.nix
    ./nix.nix
    ./nixpkgs.nix
    ./rust.nix
    ./software.nix
    ./ssh.nix
    ./sway.nix
    ./u2f.nix
    ./users.nix
  ];

  # Enable brightness control for DCC/CI monitors.
  features.ddcci.enable = true;

  # Ability to configure my Logitech G600 mouse.
  features.g600.enable = true;

  # Turn on home-manager.
  features.home-manager.enable = true;

  # Enable Video4Linux, which I may use for screen-sharing.
  features.v4l2.enable = true;

  # Enable bluetooth.
  hardware.bluetooth.enable = true;

  # Enable sound.
  hardware.pulseaudio = {
    enable = true;

    # NixOS allows either a lightweight build (default) or full build of PulseAudio to be installed.
    # Only the full build has Bluetooth support, so it must be selected here.
    package = pkgs.pulseaudioFull;
  };

  # Needed for zfs. It's just 8 random hex digits.
  networking.hostId = "6bd5a82e";

  # This value determines the NixOS release from which the default settings for
  # stateful data, like file locations and database versions on your system
  # were taken.
  #
  # It's perfectly fine (and recommended) to leave this value at the release
  # version of the first install of this system.
  #
  # Before changing this value read the documentation for this option.
  system.stateVersion = "20.03";

  # I'm in the eastern timezone.
  time.timeZone = "America/New_York";
}
