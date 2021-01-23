{ self, nixpkgs, ... } @ inputs:

let
  inherit (nixpkgs) lib;
  inherit (lib) filterAttrs listToAttrs mapAttrs' mkDefault nixosSystem;

  defaultModules = name: [
    # Some useful flake-specific stuff.
    ./modules/flakes.nix

    # Load all the features modules.
    ./modules/features.nix

    # The host's entrypoint module.
    (./hosts + "/${name}/configuration.nix")
  ];

  defaultSystem = "x86_64-linux";

  flakes = mapAttrs' renameSelf (filterAttrs onlyFlakes inputs);

  mkHost = { name, system ? defaultSystem, modules ? defaultModules name }: {
    inherit name;
    value = nixosSystem {
      inherit modules system;
      extraModules = [
        # Make input flakes available as an argument.
        { _module.args.flakes = flakes; }

        # Use name as the default hostname.
        { networking.hostName = mkDefault name; }
      ];
    };
  };

  mkHosts = list: listToAttrs (map mkHost list);

  onlyFlakes = name: value: if value ? flake then value.flake else true;

  renameSelf = name: value: {
    inherit value;

    # Rename self to nixos-config.
    name = if name == "self" then "nixos-config" else name;
  };
in

{
  nixosConfigurations = mkHosts [
    { name = "andy-thelio"; }
  ];

  overlay = final: prev: import ./overlay.nix {
    inherit final prev inputs;
  };

  /*
  packages.x86_64-linux.mdloader = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/mdloader {
    inherit (inputs) mdloader;
  };
  */
}
