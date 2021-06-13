{
  description = "Andy's NixOS Configurations";

  inputs.flake-utils = {
    url = "github:numtide/flake-utils";
  };

  inputs.home-manager = {
    url = "github:nix-community/home-manager";

    inputs.nixpkgs.follows = "nixpkgs";
  };

  # Use a newer version which added basic support for the G-shift mode,
  # meaning more buttons.
  #
  # It still doesn't support configuring the shifted color, and the piper UI
  # hasn't been updated yet.
  inputs.libratbag = {
    url = "github:libratbag/libratbag";
    flake = false;
  };

  # A tool for flashing my Drop CTRL keyboard.
  inputs.mdloader = {
    url = "github:Massdrop/mdloader";
    flake = false;
  };

  inputs.neovim-contrib = {
    url = "github:neovim/neovim?dir=contrib";

    inputs.flake-utils.follows = "flake-utils";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.nixpkgs = {
    url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  inputs.nixpkgs-wayland = {
    url = "github:colemickens/nixpkgs-wayland";

    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.rust-overlay = {
    url = "github:oxalica/rust-overlay";

    inputs.flake-utils.follows = "flake-utils";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, ... } @ inputs: import ./outputs.nix inputs;
}
