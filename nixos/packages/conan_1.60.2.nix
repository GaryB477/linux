## ----
## This file was copied and modified from git user dvetutenv 
## https://github.com/dvetutnev/dotfiles/blob/e90fd5805889a7a8c7097154562cbb0e124f0b63/conan_1.nix#L29
## ----

{ lib
, stdenv
, fetchFromGitHub
, fetchPypi
, git
, pkg-config
, python3
, zlib
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      # conan v1.xx requires old semver instead of node-semver
      semver = super.semver.overridePythonAttrs (old: rec {
        version = "0.6.1";
        src = fetchPypi {
          inherit (old) pname;
          inherit version;
          sha256 = "4016f7c1071b0493f18db69ea02d3763e98a633606d7c7beca811e53b5ac66b7";
        };
        doCheck = false;
      });
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "conan";
  version = "1.60.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "conan-io";
    repo = "conan";
    rev = "refs/tags/${version}";
    sha256 = "054l4bv864id1c3pp6plc6af63cbpi9x9xznbqi0zfl8i35ipv3j";
  };

  nativeBuildInputs = with python.pkgs; [
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = with python.pkgs; [
    bottle
    colorama
    python-dateutil
    deprecation
    distro
    fasteners
    future
    jinja2
    patch-ng
    pluginbase
    pygments
    pyjwt
    pylint # Not in `requirements.txt` but used in hooks, see https://github.com/conan-io/conan/pull/6152
    pyyaml
    semver
    requests
    six
    tqdm
    urllib3
  ] ++ lib.optionals stdenv.isDarwin [
    idna
    cryptography
    pyopenssl
  ];

  pythonRelaxDeps = [
    # This can be removed once conan is updated to 2.0.7+
    "PyYAML"
  ];

  nativeCheckInputs = [
    git
    pkg-config
    zlib
  ] ++ (with python.pkgs; [
    mock
    parameterized
    pytest-xdist
    pytestCheckHook
    webtest
  ]);

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [
    "conan"
  ];

  pytestFlagsArray = [
    "-n"
    "$NIX_BUILD_CORES"
  ];

  doCheck = false;
  disabledTests = [
    # Tests require network access
    "TestFTP"
  ] ++ lib.optionals stdenv.isDarwin [
    # Rejects paths containing nix
    "test_conditional_os"
    # Requires Apple Clang
    "test_detect_default_compilers"
    "test_detect_default_in_mac_os_using_gcc_as_default"
    # Incompatible with darwin.xattr and xcbuild from nixpkgs
    "test_dot_files"
    "test_xcrun"
    "test_xcrun_in_required_by_tool_requires"
    "test_xcrun_in_tool_requires"
  ];

  disabledTestPaths = [
    # Requires cmake, meson, autotools, apt-get, etc.
    "conans/test/functional/layout/test_editable_cmake.py"
    "conans/test/functional/layout/test_in_subfolder.py"
    "conans/test/functional/layout/test_source_folder.py"
    "conans/test/functional/toolchains/"
    "conans/test/functional/tools_versions_test.py"
    "conans/test/functional/tools/scm/test_git.py"
    "conans/test/functional/tools/system/package_manager_test.py"
    "conans/test/unittests/tools/env/test_env_files.py"
  ];

  meta = with lib; {
    description = "Decentralized and portable C/C++ package manager";
    homepage = "https://conan.io";
    changelog = "https://github.com/conan-io/conan/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ kuznetsss ];
  };
}
