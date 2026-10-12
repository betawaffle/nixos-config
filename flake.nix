{
  description = "Andy's NixOS Configurations";

  inputs.agenix = {
    type = "github";
    owner = "ryantm";
    repo = "agenix";

    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.flake-compat = {
    type = "github";
    owner = "edolstra";
    repo = "flake-compat";
    flake = false;
  };

  inputs.flake-utils = {
    type = "github";
    owner = "numtide";
    repo = "flake-utils";
  };

  inputs.home-manager = {
    type = "github";
    owner = "nix-community";
    repo = "home-manager";

    inputs.flake-compat.follows = "flake-compat";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.lib-aggregate = {
    type = "github";
    owner = "nix-community";
    repo = "lib-aggregate";

    inputs.flake-utils.follows = "flake-utils";
    inputs.nixpkgs-lib.follows = "nixpkgs-lib";
  };

  # Use a newer version which added basic support for the G-shift mode,
  # meaning more buttons.
  #
  # It still doesn't support configuring the shifted color, and the piper UI
  # hasn't been updated yet.
  inputs.libratbag = {
    type = "github";
    owner = "libratbag";
    repo = "libratbag";
    flake = false;
  };

  # A tool for flashing my Drop CTRL keyboard.
  inputs.mdloader = {
    type = "github";
    owner = "Massdrop";
    repo = "mdloader";
    flake = false;
  };

  inputs.neovim-contrib = {
    type = "github";
    owner = "neovim";
    repo = "neovim";
    dir = "contrib";

    inputs.flake-utils.follows = "flake-utils";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.nixpkgs = {
    type = "github";
    owner = "NixOS";
    repo = "nixpkgs";
    ref = "nixos-unstable";
  };

  inputs.nixpkgs-lib = {
    type = "github";
    owner = "nix-community";
    repo = "nixpkgs.lib";
  };

  inputs.nixpkgs-wayland = {
    type = "github";
    owner = "nix-community";
    repo = "nixpkgs-wayland";

    inputs.flake-compat.follows = "flake-compat";
    inputs.lib-aggregate.follows = "lib-aggregate";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.river = {
    type = "github";
    owner = "riverwm";
    repo = "river";
    flake = false;

    # type = "git";
    # url = "file:///home/betawaffle/projects/river";
    # ref = "master";
  };

  inputs.wlopm = {
    type = "sourcehut";
    owner = "~leon_plickat";
    repo = "wlopm";
    flake = false;
    # url = "sourcehut:~leon_plickat/wlopm";
  };

  inputs.zig-overlay = {
    type = "github";
    owner = "arqv";
    repo = "zig-overlay";

    inputs.flake-utils.follows = "flake-utils";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.zig-pixman = {
    type = "github";
    owner = "ifreund";
    repo = "zig-pixman";
    flake = false;

    # rev = "d381567de9b6e40dd7f4c6e0b5740f94ebd8c9d7";
  };

  inputs.zig-wayland = {
    type = "github";
    owner = "ifreund";
    repo = "zig-wayland";
    flake = false;

    # rev = "c19ffc58a88573df3e47c08599c472eb715ef7a5";
  };

  inputs.zig-wlroots = {
    type = "github";
    owner = "swaywm";
    repo = "zig-wlroots";
    flake = false;

    # rev = "597b2448319caa90ebe3625dd03ce925dee08b11";
  };

  inputs.zig-xkbcommon = {
    type = "github";
    owner = "ifreund";
    repo = "zig-xkbcommon";
    flake = false;

    # rev = "0f6eda023e6f52ea001c597fda0a7c3e7a2ccce0";
  };

  outputs = { self, ... } @ inputs: import ./outputs.nix inputs;
}
