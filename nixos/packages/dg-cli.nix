{pkgs}:
with pkgs.python3Packages;
  buildPythonPackage rec {
    name = "dg-cli";
    format = "pyproject";
    src = /home/marc/git/nixos/Dg.Cli/src/core;
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
    ];
  }
