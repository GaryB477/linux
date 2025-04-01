# with import <nixpkgs> { };
{ pkgs, ... }:

with pkgs.python3Packages;

buildPythonPackage rec {
  pname = "pytest-kind";
  version = "22.11.1";
  # pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "rnpMdT/Lv55EoMxYfVIZoLiysee8ycvhQjT3Rd1dtoE=";
  };

  doCheck = false;

  build-system = [ poetry-core cython setuptools ];

  buildInputs = [ poetry-core cachetools ];

  # pythonImportsCheck = [ "${pname}" ];

  nativeCheckInputs = [ pytestCheckHook ];
}
