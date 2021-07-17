{ pkgs, ... }:
{
  imports = [
    ./syncthing.nix
    ./tailscale.nix
  ];

  # Make NeoVim the default editor, for the whole system.
  environment.variables.EDITOR = "nvim";

  # Install things for all users.
  environment.systemPackages = with pkgs; [
    # Some alternatives to common unix tools.
    bat     # cat
    dogdns  # dig
    fd      # find
    hexyl   # hexdump
    htop    # top
    lf      # ls
    ripgrep # grep

    # Common stuff everyone wants.
    curl
    file
    fzf
    jq
    lsof
    tcpdump
    wget

    # WireGuard configuration tooling.
    wireguard
    wireguard-tools

    # PCI Utilities (for lspci and friends).
    pciutils

    # Like Alfred, but for Linux.
    albert

    # The kitty terminal emulator.
    kitty

    # NeoVim, my editor of choice.
    #
    # The unwrapped one because I don't want the stuff NixOS normally adds.
    neovim #-unwrapped

    # The stupid content tracker.
    git

    # Encryption for humans.
    age

    # The programming languages I use.
    go
    zig zls

    # Caddy, for serving my web stuff, and Hugo, for generating the static
    # parts of it.
    caddy
    hugo

    # Firefox, but for Wayland.
    firefox-wayland

    # Blender, for 3D modeling.
    blender

    # For debugging and stuff.
    gdb
    bpftool

    # Moar man pages!
    man-pages

    # For accessing the serial console on my apu2e4.
    picocom

    # For flashing my keyboard firmware.
    mdloader

    # Misc stuff
    bluez
    evtest
    hid-listen
    nix-index
    tmate
    zeal

    # Games
    minecraft
    dialog

    # This has something to do with warning messages.
    hicolor-icon-theme

    # Not actively using these yet, but I want them installed.
    cachix
    casync
    direnv
    flashrom

    # Not sure what this is for at the moment.
    xdg_utils

    # Custom stuff
    unload-iptables

    # Other stuff I had installed before, but am not currently using:
    #
    # _1password chromium freecad kea jd jid jo
  ];

  # BPF Compiler Collection
  programs.bcc.enable = true;

  # I use fish as my shell. This installs it and does some other stuff to make
  # it an allowed shell on NixOS.
  programs.fish.enable = true;

  # Use nix-index for command-not-found behavior, since we don't have a root
  # channel.
  programs.command-not-found.enable = false;
  programs.fish.shellInit = let
    wrapper = pkgs.writeScript "command-not-found" ''
      #!${pkgs.bash}/bin/bash
      source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
      command_not_found_handle "$@"
    '';
  in ''
    function __fish_command_not_found_handler --on-event fish_command_not_found
      ${wrapper} $argv
    end
  '';

  # Less (the alternative to more)
  programs.less.enable = true;

  # Matt's Traceroute
  programs.mtr.enable = true;

  # Steam
  programs.steam.enable = true;

  # Bluetooth
  services.blueman.enable = true;

  # Keybase
  services.kbfs.enable = true;
  services.keybase.enable = true;

  # Lorri seems cool, let's try it.
  services.lorri.enable = true;

  # Not sure what this is for.
  services.upower.enable = true;
}
