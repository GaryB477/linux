# with import <nixpkgs> { };
{ pkgs, ... }:

with pkgs.python3Packages;

buildPythonPackage rec {
  pname = "asyncache";
  version = "0.3.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mh5gp1Zo55RldIm96mVA7n4yWcSDUXuTRnDbdgC/UDU=";
  };

  doCheck = false;

  build-system = [ cython setuptools ];

  buildInputs = [ poetry-core cachetools ];

  pythonImportsCheck = [ "${pname}" ];

  nativeCheckInputs = [ pytestCheckHook ];
}
