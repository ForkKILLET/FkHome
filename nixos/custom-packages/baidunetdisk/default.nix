{ pkgs ? import <nixpkgs> {} }:
with pkgs;
stdenv.mkDerivation rec {
  pname = "baidunetdisk";
  version = "4.17.7";

  src = fetchurl {
    url = "https://136892-1863975051.antpcdn.com:19001/b/pkg-ant.baidu.com/issue/netdisk/LinuxGuanjia/${version}/baidunetdisk_${version}_amd64.deb";
    hash = "sha256-UOwY8FYmoT9X7wNGMEFtSBaCvBAYU58zOX1ccbxlOz0=";
  };
  sourceRoot = ".";

  nativeBuildInputs = [
    dpkg
    makeShellWrapper
  ];

  unpackCmd = "dpkg-deb -x ${src} .";

  dontConfigure = true;
  dontBuild = true;

  installPhase =
  let
    libPath = lib.makeLibraryPath [
      glib                  # libgobject-2.0.so.0, libglib-2.0.so.0, libgio-2.0.so.0, 
      nss_latest            # libnss3.so, libnssutil3.so, libsmime3.so
      nspr                  # libnspr4.so
      at-spi2-atk           # libatk-1.0.so.0, libatk-bridge-2.0.so.0, libatspi.so.0
      dbus.lib              # libdbus-1.so.3
      gdk-pixbuf            # libgdk_pixbuf-2.0.so.0
      gtk3                  # libgtk-3.so.0, libgdk-3.so.0
      pango                 # libpango-1.0.so.0, libpangocairo-1.0.so.0
      cairo                 # libcairo.so.2
      xorg.libX11           # libX11.so.6, libX11-xcb.so.1
      xorg.libXcomposite    # libXcomposite.so.1
      xorg.libXdamage       # libXdamage.so.1
      xorg.libXext          # libXext.so.6
      xorg.libXfixes        # libXfixes.so.3
      xorg.libXrandr        # libXrandr.so.2
      xorg.libxcb           # libxcb.so.1
      expat                 # libexpat.so.1
      libdrm                # libdrm.so.2
      libxkbcommon          # libxkbcommon.so.0
      mesa                  # libgbm.so.1
      alsa-lib              # libasound.so.2
      cups.lib              # libcups.so.2
    ];
  in ''
    runHook preInstall

    mkdir -p $out/bin
    cp -R usr/share opt $out/

    substituteInPlace \
      $out/share/applications/baidunetdisk.desktop \
      --replace /opt/ $out/opt/

    patchelf \
      --set-interpreter ${stdenv.cc.bintools.dynamicLinker} \
      --set-rpath "${libPath}"\
      $out/opt/baidunetdisk/baidunetdisk

    wrapProgramShell \
      $out/opt/baidunetdisk/baidunetdisk \
      --prefix LD_LIBRARY_PATH : "$out/opt/baidunetdisk"

    ln -s $out/opt/baidunetdisk/baidunetdisk $out/bin/baidunetdisk

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://pan.baidu.com/download";
    description = "Baidu Netdisk";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = [ "ForkKILLET" ];
  };
}