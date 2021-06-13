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

  # Evaluates the nixos configuration for a host.
  mkHost = { name, system ? defaultSystem, modules ? defaultModules name }: {
    inherit name;
    value = nixosSystem {
      inherit modules system;

      # These arguments need to be in `specialArgs` so they can be used in
      # `imports`. If we used `_module.args` instead, such references would
      # cause an infinite loop. I learned this the hard way.
      specialArgs = {
        # Separate flakes from non-flakes.
        flakes = mapAttrs' renameSelf (filterAttrs onlyFlakes inputs);
        inputs = filterAttrs onlyNonFlakes inputs;
      };

      extraModules = [
        # Use name as the default hostname.
        { networking.hostName = mkDefault name; }
      ];
    };
  };

  # Builds an attribute set of evaluated nixos configurations from a list.
  mkHosts = list: listToAttrs (map mkHost list);

  # Used to exclude non-flake inputs.
  onlyFlakes = name: value: if value ? flake then value.flake else true;

  # Used to exclude flake inputs.
  onlyNonFlakes = name: value: if value ? flake then !value.flake else false;

  # Used to rename the `self` flake to `nixos-config`.
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
