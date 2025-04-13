{ pkgs ? import <nixpkgs> {} }:
with pkgs;
with python3Packages;
buildPythonPackage rec {
  pname = "stcgal";
  version = "1.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "31db4f7ee1a1eb193941c6e4728fbb47874a467b02128a7d3915aaf60da658f7";
  };

  doCheck = false;
  pyproject = false;

  build-system = [
    setuptools
    wheel
  ];
}
