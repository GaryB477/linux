{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPypi,
  git,
  pkg-config,
  python3,
  zlib,
}:
python3.pkgs.buildPythonPackage rec {
  pname = "conan_tools";
  version = "1.4.3";

  # Should be downloaded automatically from the git repot
  # .. but thats kind of a pain in the buttox since we always need access to this repo which requires a running VPN :)
  src = /home/marc/medivation/git/ConanTools;
  doCheck = false;

  nativeBuildInputs = [python3.pkgs.setuptools_scm git];

  meta = with lib; {
    homepage = https://gitlab-medivation.at-nine.ch/medivation/buildtools/ConanTools;
    description = "Helper script to handle conan dependenceis";
    #license = licenses.bsd3;
    maintainers = with maintainers; [Timothe];
  };
}
