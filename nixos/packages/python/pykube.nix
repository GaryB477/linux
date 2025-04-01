# with import <nixpkgs> { };
{ pkgs, ... }:

with pkgs.python3Packages;

buildPythonPackage rec {
  pname = "pykube";
  version = "0.15.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5TgA0NRfE5EapOvKhGOuXMgq+tRh9ldaCiF9L85fCIs=";
  };

  doCheck = false;

  build-system = [ cython setuptools ];

  buildInputs = [ poetry-core cachetools pyyaml ];

  dependencies = [ six requests tzlocal requests_oauthlib oauth2client ];

  pythonImportsCheck = [ "${pname}" ];

  nativeCheckInputs = [ pytestCheckHook ];
}
