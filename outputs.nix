{ self, nixpkgs, ... } @ inputs:

let
  inherit (nixpkgs) lib;
  inherit (lib) listToAttrs mapAttrs' mkDefault nixosSystem;

  defaultModules = name: [
    # Some useful flake-specific stuff.
    ./modules/flakes.nix

    # Load all the features modules.
    ./modules/features.nix

    # The host's entrypoint module.
    (./hosts + "/${name}/configuration.nix")
  ];

  defaultSystem = "x86_64-linux";

  mkHost = { name, system ? defaultSystem, modules ? defaultModules name }: {
    inherit name;
    value = nixosSystem {
      inherit modules system;
      extraModules = [
        # Make input flakes available as an argument.
        { _module.args.flakes = mapAttrs' renameSelf inputs; }

        # Use name as the default hostname.
        { networking.hostName = mkDefault name; }
      ];
    };
  };

  mkHosts = list: listToAttrs (map mkHost list);

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
}
