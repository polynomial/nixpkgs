{ plasmaPackage
, extra-cmake-modules
, baloo
, kactivities
, kconfig
, kcoreaddons
, kdeclarative
, kguiaddons
, ki18n
, kio
, kservice
, kfilemetadata
, plasma-framework
, qtdeclarative
, qtmultimedia
, taglib
}:

plasmaPackage {
  name = "plasma-mediacenter";
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    baloo
    kactivities
    kconfig
    kcoreaddons
    kdeclarative
    kguiaddons
    ki18n
    kio
    kservice
    kfilemetadata
    plasma-framework
    qtdeclarative
    qtmultimedia
    taglib
  ];
}
