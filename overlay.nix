{ final, prev, inputs }:
{
  libratbag = prev.libratbag.overrideAttrs (old: {
    version = inputs.libratbag.rev;
    src = inputs.libratbag;
  });

  mdloader = final.stdenv.mkDerivation {
    pname = "mdloader";
    version = inputs.mdloader.rev;
    src = inputs.mdloader;

    installPhase = ''
      mkdir -p $out/bin/
      mv build/* $out/bin/
    '';
  };
}
