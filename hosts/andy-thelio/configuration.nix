{ config, hosts, pkgs, ... }:
{
  imports = [
    ../../modules/agenix.nix
    ../../modules/arduino.nix
    ../../modules/bluetooth.nix
    ../../modules/common.nix
    ../../modules/console.nix
    ../../modules/cpu/amd-threadripper-3970x.nix
    ../../modules/ddcci.nix
    ../../modules/eda-tools.nix
    ../../modules/efi.nix
    ../../modules/firecracker.nix
    ../../modules/fish.nix
    ../../modules/fonts.nix
    ../../modules/g600-mouse.nix
    ../../modules/games.nix
    ../../modules/gpu/amd-5700xt.nix
    ../../modules/greetd.nix
    ../../modules/gtk.nix
    ../../modules/home-manager.nix
    ../../modules/keybase.nix
    ../../modules/mako.nix
    ../../modules/neovim.nix
    ../../modules/networkd.nix
    ../../modules/nftables.nix
    ../../modules/nix.nix
    ../../modules/nixpkgs.nix
    ../../modules/nvme.nix
    ../../modules/pam.nix
    ../../modules/passwordless.nix
    ../../modules/powertop.nix
    ../../modules/river.nix
    ../../modules/rust.nix
    ../../modules/sound.nix
    ../../modules/ssh-server.nix
    ../../modules/syncthing.nix
    ../../modules/tailscale.nix
    ../../modules/video4linux.nix
    ../../modules/wayland.nix
    ../../modules/wezterm.nix
    ../../modules/xdg.nix
    ../../modules/zfs-root.nix
    ../../modules/zfs-scrub.nix
    ../../modules/zfs-trim.nix
    ../../modules/zig.nix

    ../../modules/netbox.nix

    #../../modules/bpf.nix
    #../../modules/rdma.nix
    #../../modules/ipfs.nix

    ./network.nix
  ];

  # Use the latest linux kernel I can.
  boot.kernelPackages = pkgs.zfsStable.latestCompatibleLinuxPackages;
  # pkgs.linuxPackages_5_10; # pkgs.zfsStable.latestCompatibleLinuxPackages;

  boot.extraModulePackages = with config.boot.kernelPackages; [
    rapiddisk
  ];

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

  environment.enableDebugInfo = true;

  environment.etc."nixos/flake.nix".source = "/home/betawaffle/projects/nixos-config/flake.nix";

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
    cntr
    darktable
    delta
    direnv
    dogdns
    evtest
    fd
    firefox-wayland
    flashrom
    fzf
    gdb
    git
    go_1_17
    hexyl
    hicolor-icon-theme
    hid-listen
    hugo
    hwloc
    kitty
    lf
    llvmPackages_13.libllvm
    logiops
    man-pages
    mdloader
    nix-direnv
    nix-index
    obsidian
    picocom
    radare2
    smartmontools
    sqlite-interactive
    tmate
    unload-iptables
    xdg_utils
    zeal
    zoxide

    qmk-udev-rules
    vial

    river-updated

    clang-tools
    cmake

    nbd
    nvmet-cli
    qemu
    rustdesk
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

  services.mako.enable = true;
  services.pipewire.enable = true;

  # Don't leave any processes running from logged-out sessions.
  services.logind.killUserProcesses = true;

  # PostgreSQL
  services.postgresql.enable = true;
  services.postgresql.package = pkgs.postgresql_14;
  services.postgresql.ensureDatabases = [
    "betawaffle"
    "tormem"
  ];
  services.postgresql.ensureUsers = [
    {
      name = "betawaffle";
      ensurePermissions = {
        "DATABASE betawaffle" = "ALL PRIVILEGES";
      };
    }
    {
      name = "tormem";
      ensurePermissions = {
        "DATABASE tormem" = "ALL PRIVILEGES";
      };
    }
  ];
  services.postgresql.identMap = ''
    tormem betawaffle tormem
    tormem root       tormem
  '';
  services.postgresql.authentication = ''
    local all tormem peer map=tormem
  '';
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
      "disk"
    ];

    # Allow me to SSH into this machine, from my other machine(s).
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 ${hosts.andy-mac-pro.ssh-public-keys.user.betawaffle.ed25519} betawaffle@andy-mac-pro"
    ];
  };

  # Allow the router to SSH in as root to run nix builds.
  #
  # FIXME: I should reverse the direction of this, and build/deploy from here
  # to the router.
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 ${hosts.router.ssh-public-keys.user.root.ed25519} root@router"
  ];
}
