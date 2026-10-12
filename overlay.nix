{ self
, libratbag
, mdloader
, wlopm
, zig-overlay
, ...
} @ inputs:

final: prev:

{
  avra = final.callPackage ./packages/avra.nix {};

  # iosekva-bin-variants = final.callPackage ./packages/iosevka-bin-variants.nix {};

  libratbag = prev.libratbag.overrideAttrs (_old: {
    version = libratbag.rev;
    src = libratbag;
  });

  linuxKernel = prev.linuxKernel // {
    packagesFor = kernel_: (prev.linuxKernel.packagesFor kernel_).extend self.overlays.kernel-packages;
  };

  mdloader = final.callPackage ./packages/mdloader.nix { inherit mdloader; };

  #neovim = final.callPackage ./packages/neovim.nix {};
  #neovim-unwrapped = inputs.neovim-contrib.packages.${prev.system}.neovim;

  river-updated = final.callPackage ./packages/river-updated.nix {
    inherit (inputs) zig-pixman zig-wayland zig-wlroots zig-xkbcommon;

    src = inputs.river;
  };

  wezterm-updated = final.callPackage ./packages/wezterm-updated.nix {
    inherit (final.darwin.apple_sdk.frameworks) Cocoa CoreGraphics Foundation;

    version = "20220624-141144-bd1b7c5d";
    sha256 = "sha256-7VuNOJ4xqTxumLft7wRj4zdN8Y2ZSYtXr/KuqaLNOgw=";
    cargoSha256 = "sha256-YvQ0APyPiYwISE/pDD2s+UgYFj4CKPdolb14FrNpocU=";
  };

  wlopm = final.callPackage ./packages/wlopm.nix { inherit wlopm; };

  zig-master = zig-overlay.packages.${final.system}.master.latest;

  zls-override = final.callPackage ./packages/zls-override.nix {};

  zls-unstable = final.callPackage ./packages/zls-override.nix {
    zig = final.zig-master;
    rev = "fc5b1c64579e0ec33ea374051bcfef59ebfc0c5c";
    sha256 = "sha256-BM2z+YyYjPHVXXAF6rVks6roirg0ixWWlyatOqxPylE=";
  };

  # Miscellaneous Scripts
  greeter = final.callPackage ./packages/greeter.nix {};
  start-river = final.callPackage ./packages/start-river.nix {};
  start-sway = final.callPackage ./packages/start-sway.nix {};
  unload-iptables = final.callPackage ./packages/unload-iptables.nix {};
}
