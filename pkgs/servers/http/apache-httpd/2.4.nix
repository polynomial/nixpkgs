{ stdenv, fetchFromGitHub, perl, zlib, apr, aprutil, pcre, libiconv
, autoconf, which, expat # for apache build
, subversion, python, libtool # for apr
, proxySupport ? true
, sslSupport ? true, openssl
, http2Support ? true, nghttp2
, ldapSupport ? true, openldap
, libxml2Support ? true, libxml2
, luaSupport ? false, lua5
}:

let optional       = stdenv.lib.optional;
    optionalString = stdenv.lib.optionalString;
in

assert sslSupport -> aprutil.sslSupport && openssl != null;
assert ldapSupport -> aprutil.ldapSupport && openldap != null;
assert http2Support -> nghttp2 != null;

stdenv.mkDerivation rec {
  version = "2.4.25";
  name = "apache-httpd-${version}";

  src = fetchFromGitHub {
    rev = "c86718e47782449331f0f181c05f086a8985bee1";
    owner = "polynomial";
    repo = "httpd";
    sha256 = "1b2xkirn0phqjgbv2yvxn107ss65i3zb7gfnsbpk793izkdi6y3y";
  };

  # FIXME: -dev depends on -doc
  outputs = [ "out" "dev" "doc" ];
  setOutputFlags = false; # it would move $out/modules, etc.

  buildInputs = [
    autoconf
    which
    expat
    pcre
    subversion
    python
    libtool
    perl
    ] ++
      optional sslSupport openssl ++
      optional ldapSupport openldap ++    # there is no --with-ldap flag
      optional libxml2Support libxml2 ++
      optional http2Support nghttp2 ++
      optional stdenv.isDarwin libiconv;

  patchPhase = ''
    sed -i config.layout -e "s|installbuilddir:.*|installbuilddir: $dev/share/build|"
  '';

  # Required for ‘pthread_cancel’.
  NIX_LDFLAGS = stdenv.lib.optionalString (!stdenv.isDarwin) "-lgcc_s";

  preConfigure = ''
    svn co http://svn.apache.org/repos/asf/apr/apr/trunk srclib/apr
    ./buildconf
    configureFlags="$configureFlags --includedir=$dev/include"
  '';
    #--with-apr=${apr.dev}
    #--with-apr-util=${aprutil.dev}
  configureFlags = ''
    --with-included-apr
    --with-z=${zlib.dev}
    --with-pcre=${pcre.dev}
    --disable-maintainer-mode
    --disable-debugger-mode
    --enable-mods-shared=all
    --enable-mpms-shared=all
    --enable-cern-meta
    --enable-imagemap
    --enable-cgi
    ${optionalString proxySupport "--enable-proxy"}
    ${optionalString sslSupport "--enable-ssl"}
    ${optionalString http2Support "--enable-http2 --with-nghttp2"}
    ${optionalString luaSupport "--enable-lua --with-lua=${lua5}"}
    ${optionalString libxml2Support "--with-libxml2=${libxml2.dev}/include/libxml2"}
    --docdir=$(doc)/share/doc
  '';

  enableParallelBuilding = true;

  postInstall = ''
    mkdir -p $doc/share/doc/httpd
    mv $out/manual $doc/share/doc/httpd
    mkdir -p $dev/bin
    mv $out/bin/apxs $dev/bin/apxs
  '';

  passthru = {
    inherit apr aprutil sslSupport proxySupport ldapSupport;
  };

  meta = with stdenv.lib; {
    description = "Apache HTTPD, the world's most popular web server";
    homepage    = http://httpd.apache.org/;
    license     = licenses.asl20;
    platforms   = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    maintainers = with maintainers; [ lovek323 peti ];
  };
}
