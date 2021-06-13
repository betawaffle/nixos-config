{
  description = "Andy's NixOS Configurations";

  inputs.home-manager = {
    url = "github:nix-community/home-manager";
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

  inputs.neovim-nightly-overlay = {
    url = "github:nix-community/neovim-nightly-overlay";
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

    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, ... } @ inputs: import ./outputs.nix inputs;
}
