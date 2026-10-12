{ config, lib, pkgs, ... }:
{
  # Show KERN_NOTICE and below.
  boot.consoleLogLevel = 5;

  # Send kernel messages to VT 11.
  boot.kernelParams = [
    "console=tty11"
  ];

  # Resolution of the console.
  boot.loader.systemd-boot.consoleMode = "max";

  # Use gruvbox colors.
  console.colors = [
    "282828"
    "cc241d"
    "98971a"
    "d79921"
    "458588"
    "b16286"
    "689d6a"
    "a89984"
    "928374"
    "fb4934"
    "b8bb26"
    "fabd2f"
    "83a598"
    "d3869b"
    "8ec07c"
    "ebdbb2"
  ];

  # Enable VTs in initrd.
  console.earlySetup = true;

  # A better console font?
  console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";

  # Mouse support for virtual consoles.
  #services.gpm.enable = true;

  # Send journald output to VT 12.
  services.journald.console = "/dev/tty12";
}
