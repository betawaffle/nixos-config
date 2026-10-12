{ fetchFromGitHub
, zls
, zig
, rev ? "cb4e74213480113ea1af78aff70a90ba41777653"
, sha256 ? "sha256-MVo21qNCZop/HXBqrPcosGbRY+W69KNCc1DfnH47GsI="
}:

(zls.override { inherit zig; }).overrideAttrs (old: rec {
  version = rev;

  src = fetchFromGitHub {
    inherit rev sha256;

    owner = "zigtools";
    repo = old.pname;
    fetchSubmodules = true;
  };
})

