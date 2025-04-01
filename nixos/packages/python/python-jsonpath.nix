# with import <nixpkgs> { };
{ pkgs, ... }:

with pkgs.python3Packages;

buildPythonPackage rec {
  pname = "python-jsonpath";
  version = "1.3.0";
  pyproject = true;

  src = pkgs.fetchzip{
    url = "https://github.com/jg-rp/python-jsonpath/archive/refs/tags/v1.3.0.tar.gz";
    sha256 = "eP4nR+3Ltc+auiQACvIuxX7wWLh29L4Ie92DG1PivK4=";
  };

  doCheck = false;

  build-system = [ hatchling ];

  buildInputs = [  ];

  # pythonImportsCheck = [ "${pname}" ]; # did not work ;(

  nativeCheckInputs = [ pytestCheckHook ];
}
