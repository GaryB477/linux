{ pkgs }:
with pkgs.python3Packages;
let kr8s = callPackage ./python/kr8s.nix { };
in buildPythonPackage rec {
  name = "dg-cli";
  format = "pyproject";

  version = "2.4.4";
  src = pkgs.fetchzip{
    url = "https://dg-package-repositories.platform.prod.int.devinite.com/DGCLI/source/dg_cli_core-${version}.tar.gz";
    sha256 = "M/qNcnV2ijCTYp6nSAERgJp8nvhoT2p6dZuJsUkZUMs=";
  };

  preBuild = ''
    sed -E -i '
        # Start processing when we find the dependencies section
        /\[tool\.poetry\.dependencies\]/,/^\[|^$/ {
        # Skip the section header itself
        /\[tool\.poetry\.dependencies\]/b
        
        # If we encounter another section header, stop processing
        /^\[/b
        
        # Handle normal dependencies: package = "1.2.3" -> package = "*"
        s/^([a-zA-Z0-9_.-]+ = )"[^"]*"/\1"*"/g
        
        # Handle table notation: version = "1.2.3" -> version = "*"
        s/(version = )"[^"]*"/\1"*"/g
        }
    ' pyproject.toml
  ''; 

  dependencies = [ pyinstaller ];

  nativeBuildInputs = [ kr8s ];
  propagatedBuildInputs = [
    python
    typer
    colorama
    rich
    requests
    semantic-version
    psutil
    types-requests
    pydantic
    nuitka
    confluent-kafka
    questionary
    fastavro
    azure-identity
    azure-keyvault-secrets
    keyring
    keyrings-cryptfile
    ruamel-yaml
    responses
    pyodbc
    docker
    gitpython
    kubernetes
    pygithub
    pymongo
    python-snappy
    pyyaml
    poetry-core
    mergedeep
    pyperclip
    textual
  ];
}
