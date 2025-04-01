{ pkgs, unstable, ... }:

with unstable.pkgs;
with unstable.pkgs.python3Packages;

let
  asyncache = callPackage ./asyncache.nix { };
  python-jsonpath = callPackage ./python-jsonpath.nix { };
  pytest-kind = callPackage ./pytest-kind.nix { };
  pykube = callPackage ./pykube.nix { };
  unstable = import (fetchTarball
    "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") {
      config.allowUnfree = true;
    };
in buildPythonPackage rec {

  pname = "kr8s";
  version = "0.20.6";
  pyproject = true;

  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SbAXAB1/jSwqpcC4i9J32X5e8o9WAcEd7hFI2L9mnb8=";
  };

  build-system = [ cython setuptools hatchling hatch-vcs jsonpath ];

  buildInputs = [
    anyio
    asyncache
    cachetools
    cryptography
    httpx-ws
    httpx
    pykube
    pytest-kind
    python-box
    python-jsonpath
    pyyaml
  ];

  pythonImportsCheck = [ "kr8s" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Simple, extensible python client library for Kubernetes";
    homepage = "https://github.com/kr8s-org/kr8s";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
