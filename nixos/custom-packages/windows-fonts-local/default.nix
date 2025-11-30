{ pkgs }:
with pkgs;
stdenv.mkDerivation {
  pname = "windows-fonts-local";
  version = "0.1.0";
  src = /home/forkkillet/res/fonts/Windows;

  installPhase = ''
    install -m444 -Dt $out/share/fonts/truetype/Windows *.ttf
  '';

  meta = with pkgs.lib; {
    description = "Windows Fonts (local)";
    platforms = platforms.all;
    maintainers =
      let me = import ../me.nix;
      in [ me ];
  };
}