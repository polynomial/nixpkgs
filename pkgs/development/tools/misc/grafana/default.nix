{ stdenv, fetchurl, unzip, conf ? null }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "grafana-${version}";
  version = "4.1.1-1484211277";
  platform = "linux-x64";

  src = fetchurl {
    url = "https://grafanarel.s3.amazonaws.com/builds/${name}.${platform}.tar.gz";
    sha256 = "51464c7569638bbfd7c6a7397c8f5f296c6839a113360ff5f908d454a9643aeb";
  };

  buildInputs = [ unzip ];

  phases = ["unpackPhase" "installPhase"];
  installPhase = ''
    mkdir -p $out && cp -R * $out
    ${optionalString (conf!=null) ''cp ${conf} $out/config.js''}
  '';

  meta = {
    description = "Grafana provides a powerful and elegant way to create, explore, and share dashboards and data with your team and the world.";
    homepage = http://grafana.org/;
    license = licenses.asl20;

    maintainers = [ maintainers.offline ];
    platforms = stdenv.lib.platforms.unix;
  };
}
