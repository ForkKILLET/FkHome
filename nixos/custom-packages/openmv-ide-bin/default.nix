# Some scripts are from [AUR](https://aur.archlinux.org/packages/openmv-ide-bin).

{
  pkgs ? import <nixpkgs> {}
}:
let lib = pkgs.lib;
in pkgs.stdenv.mkDerivation rec {
  pname = "openmv-ide-bin";
  version = "4.5.0";

  meta = {
    homepage = "https://github.com/openmv/openmv-ide/";
    description = "QtCreator based OpenMV IDE";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers =
      let forkkillet = import ../me.nix;
      in [ forkkillet ];
  };

  src = pkgs.fetchurl {
    url = "https://github.com/openmv/openmv-ide/releases/download/v${version}/openmv-ide-linux-x86_64-${version}.tar.gz";
    sha256 = "sha256-YYhaeazmjHJ3nKhPBV6v6cTRhZq2I3LO03mptNTGqGQ=";
  };

  nativeBuildInputs = with pkgs; [
    makeWrapper
  ];

  libDeps = with pkgs; [
    fontconfig
    freetype
    xorg.libxcb
    xorg.libX11
    libxkbcommon
    libpng
    libusb1
    glib
    krb5
    dbus
    xcb-util-cursor
    xorg.xcbutilwm
    xorg.xcbutilimage
    xorg.xcbutilkeysyms
    xorg.xcbutilrenderutil
    xorg.libXinerama
    libGL
    python3Packages.pyusb
  ];

  buildInputs = libDeps;

  installPhase = let
    bin = "openmvide";
    app = "openmv-ide";
    libDepsPath = lib.makeLibraryPath libDeps;
  in ''
    _install() {
      find ${ "\${@:2}" } -type f -exec install -Dm$1 {} $out/opt/${app}/{} \;
    }

    # binary
    install -Dm755 bin/${bin} -t $out/opt/${app}/bin/
    wrapProgram $out/opt/${app}/bin/${bin} \
      --prefix LD_LIBRARY_PATH : "$out/opt/${app}/lib:${libDepsPath}" \
      --set QT_PLUGIN_PATH "$out/opt/${app}/lib/Qt/plugins" \
      --set QT_QPA_PLATFORM_PLUGIN_PATH "$out/opt/${app}/lib/Qt/plugins/platforms"

    # wrapper
    # install -Dm755 bin/${bin}.sh -t $out/opt/${app}/bin/

    # qt.conf
    install -Dm644 bin/qt.conf $out/opt/${app}/bin/qt.conf

    # lib
    _install 644 -L lib/qtcreator
    _install 644 -L lib/Qt

    # bin
    mkdir $out/bin
    ln -s $out/opt/${app}/bin/${bin} $out/bin/${bin}

    # share
    _install 644 share/qtcreator
    
    # metainfo
    _install 644 share/metainfo/

    # desktop
    install -Dm644 share/applications/io.openmv.openmvide.desktop \
      $out/share/applications/${app}.desktop
    
    # icon
    cp -r share/icons $out/share/

    # udev rules
    install -Dm644 share/qtcreator/pydfu/*.rules -t \
      $out/lib/udev/rules.d
  '';
}