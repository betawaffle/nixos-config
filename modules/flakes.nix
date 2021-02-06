{ flakes, lib, ... }:
{
  imports = [
    # We need flake support.
    ./nix-unstable.nix
  ];

  config = {
    # Pin flakes to the ones used for building the system.
    # nix.registry = lib.mapAttrs' (name: flake: { inherit name; value.flake = flake; }) flakes;

    # Configure auto-upgrade to support this flake. This doesn't enable
    # auto-upgrade, it only configures it.
    system.autoUpgrade.flags = [
      "--update-input" "nixpkgs"
      "--commit-lock-file"
    ];

    # Let nixos-version know about the Git revision of this flake.
    system.configurationRevision = lib.mkIf (flakes.nixos-config ? rev) flakes.nixos-config.rev;
  };
}
