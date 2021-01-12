{
  description = "Andy's NixOS Configurations";

  inputs.nixpkgs = {
    url = "nixpkgs/nixos-unstable";
  };

  inputs.nixpkgs-wayland = {
    url = "github:colemickens/nixpkgs-wayland";

    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, ... } @ inputs: import ./outputs.nix inputs;
}
