{stdenv, fetchFromGitHub, buildRebar3, ibrowse, jsx, erlware_commons, getopt }:

buildRebar3 rec {
    name = "hex2nix";
    version = "0.0.6";

    src = fetchFromGitHub {
      owner = "erlang-nix";
      repo = "hex2nix";
      rev = "${version}";
      sha256 = "17rkzg836v7z2xf0i5m8zqfvr23dbmw1bi3c83km92f9glwa1dbf";
    };

    beamDeps = [ ibrowse jsx erlware_commons getopt ];

    DEBUG=1;

    installPhase = ''
      runHook preInstall
      make PREFIX=$out install
      runHook postInstall
    '';
 }
