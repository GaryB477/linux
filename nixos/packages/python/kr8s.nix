{ pkgs, system ? builtins.currentSystem, ... }:

let
  asyncache = pkgs.callPackage ./asyncache.nix { };
  python-jsonpath = pkgs.callPackage ./python-jsonpath.nix { };
  pytest-kind = pkgs.callPackage ./pytest-kind.nix { };
  pykube = pkgs.callPackage ./pykube.nix { };
  unstable = import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
    sha256 = "06qsbbjv3gmrx6bppzkrcigh7mxwshd6a8wszhll0sn952chyqbf";
  }) {
    inherit system;
    config.allowUnfree = true;
  };
in with unstable.pkgs;
with unstable.pkgs.python3Packages;

buildPythonPackage rec {
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
    cachetools
    cryptography
    httpx-ws
    httpx
    python-box
    pyyaml
  ];

  # use native instead or normal buildInputs to avoid python version conflicts
  nativeBuildInputs = [ 
    asyncache
    python-jsonpath
    pytest-kind
    pykube
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
