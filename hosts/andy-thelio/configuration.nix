{ config, pkgs, sshPublicKeys, ... }:
{
  imports = [
    ../../modules/bluetooth.nix
    ../../modules/bpf.nix
    ../../modules/common.nix
    ../../modules/cpu/amd-threadripper-3970x.nix
    ../../modules/ddcci.nix
    ../../modules/efi.nix
    ../../modules/fish.nix
    ../../modules/fonts.nix
    ../../modules/g600-mouse.nix
    ../../modules/games.nix
    ../../modules/gpu/amd-5700xt.nix
    ../../modules/home-manager.nix
    ../../modules/keybase.nix
    ../../modules/neovim.nix
    ../../modules/networkd.nix
    ../../modules/nftables.nix
    ../../modules/nix.nix
    ../../modules/nixpkgs.nix
    ../../modules/nvme.nix
    ../../modules/pam.nix
    ../../modules/passwordless.nix
    ../../modules/rust.nix
    ../../modules/sound.nix
    ../../modules/ssh-server.nix
    ../../modules/sway.nix
    ../../modules/syncthing.nix
    ../../modules/tailscale.nix
    ../../modules/video4linux.nix
    ../../modules/zfs-root.nix
    ../../modules/zfs-scrub.nix
    ../../modules/zfs-trim.nix
    ../../modules/zig.nix

    #../../modules/ipfs.nix

    ./network.nix
  ];

  # Use the latest linux kernel I can.
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  # More console output?
  boot.loader.systemd-boot.consoleMode = "max";

  # Speed up booting slightly by not waiting at the menu.
  boot.loader.timeout = 1;

  common.espUUID = "8EDB-66A5";

  common.zfsRoot.datasets = {
    "/"    = "rpool/system/root";
    "/nix" = "rpool/local/nix";
    "/var" = "rpool/system/var";

    "/home"            = "rpool/user/home";
    "/home/betawaffle" = "rpool/user/home/betawaffle";
  };

  # Enable developer documentation (man, info, doc).
  documentation.dev.enable = true;

  # Install things for all users.
  environment.systemPackages = with pkgs; [
    age
    albert
    apcupsd
    bat
    blender
    cachix
    caddy
    casync
    darktable
    direnv
    dogdns
    evtest
    fd
    firefox-wayland
    flashrom
    fzf
    gdb
    git
    go
    hexyl
    hicolor-icon-theme
    hid-listen
    hugo
    hwloc
    kitty
    lf
    man-pages
    mdloader
    nix-index
    picocom
    smartmontools
    tmate
    unload-iptables
    xdg_utils
    zeal
  ];

  # Pictures on Mnemosyne.
  fileSystems."/mnt/pictures" = {
    device = "192.168.0.8:/volume2/Pictures";
    fsType = "nfs";

    options = [ "ro" "soft" "bg" "x-systemd.automount" "noauto" ];
  };

  # Needed for zfs. It's just 8 random hex digits.
  networking.hostId = "6bd5a82e";

  # Configure nftables rules.
  networking.nftables.ruleset = ''
  '';

  # Ethernet is good enough for now.
  networking.wireless.enable = false;

  # Don't leave any processes running from logged-out sessions.
  services.logind.killUserProcesses = true;

  # Lorri seems cool, let's try it.
  services.lorri.enable = true;

  # PostgreSQL
  services.postgresql.enable = true;
  services.postgresql.package = pkgs.postgresql_13;
  services.postgresql.ensureDatabases = [
    "betawaffle"
  ];
  services.postgresql.ensureUsers = [
    {
      name = "betawaffle";
      ensurePermissions = {
        "DATABASE betawaffle" = "ALL PRIVILEGES";
      };
    }
  ];
  services.postgresql.settings = {
    wal_level = "logical";
    max_wal_senders = 10;
    max_replication_slots = 10;
  };

  # FIXME: This is a hack, stop doing this!
  services.syncthing.user = "betawaffle";

  # Not sure what this is for.
  services.upower.enable = true;

  # Before changing this value read the documentation for this option.
  system.stateVersion = "20.03";

  # Set up the user dbus socket by default.
  systemd.user.sockets.dbus.wantedBy = [ "sockets.target" ];

  # Define my user.
  users.users.betawaffle = {
    uid = 1000;
    isNormalUser = true;
    shell = "/run/current-system/sw/bin/fish";
    extraGroups = [
      "video"
      "wheel"   # for sudo
      "dialout" # for mdloader
    ];

    # Allow me to SSH into this machine, from my other machine(s).
    openssh.authorizedKeys.keys = [
      sshPublicKeys.andy-mac-pro
    ];
  };

  # Allow the router to SSH in as root to run nix builds.
  #
  # FIXME: I should reverse the direction of this, and build/deploy from here
  # to the router.
  users.users.root.openssh.authorizedKeys.keys = [
    sshPublicKeys.router
  ];
}
