{ stdenv, buildGoPackage, fetchFromGitHub, makeWrapper }:

buildGoPackage rec {
  name = "carbon-relay-ng-${version}";
  version = "0.11.0";
  goPackagePath = "github.com/graphite-ng/carbon-relay-ng";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
  '';

  src = fetchFromGitHub {
    owner = "graphite-ng";
    repo = "carbon-relay-ng";
    rev = "v${version}";
    sha256 = "19wk8zmc361rllyw3h09m41nn73zqk0w2nn7az2skfca3j5hwwmi";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/graphite-ng/carbon-relay-ng/;
    description = "Fast carbon relay+aggregator with admin interfaces for making changes online - production ready";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.polynomial ];
  };
}
