{stdenv
, fetchFromGitHub
, buildRebar3
, cuttlefish
}:

buildRebar3 rec {
    name = "dalmatinerdb";
    version = "v0.3.2-b243";

    src = fetchFromGitHub {
      owner = "${name}";
      repo = "${name}";
      rev = "${version}";
      sha256 = "17fvlabcf95irxbxh0bs829jymzyrd7kmv6j9p4csrhk2fj0z9sx";
    };

    beamDeps = [ cuttlefish ];

    DEBUG=1;

    installPhase = ''
      runHook preInstall
      make PREFIX=$out all rel
      runHook postInstall
    '';
 }
