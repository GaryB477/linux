let 
  pkgs = import <nixpkgs> {};
  version = "5.6.49";
in pkgs.stdenv.mkDerivation {
  name = "master-pdf-editor-${version}";

  src = /home/marc/Downloads/master-pdf-editor-5.6.49.deb;

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ pkgs.dpkg ];

  installPhase = ''
    mkdir -p $out/bin
    cp -R usr/share opt $out/
    # fix the path in the desktop file
    substituteInPlace \
      $out/share/applications/masterpdfeditor5.desktop \
      --replace /opt/ $out/opt/ \
      --replace ".sh" ""
    # symlink the binary to bin/
    ln -s $out/opt/master-pdf-editor-5/masterpdfeditor5 $out/bin/masterpdfeditor5
  '';
  preFixup = let
    # we prepare our library path in the let clause to avoid it become part of the input of mkDerivation
    libPath = pkgs.lib.makeLibraryPath [
      pkgs.qt5.qtbase        # libQt5PrintSupport.so.5
      pkgs.qt5.qtsvg         # libQt5Svg.so.5
      pkgs.stdenv.cc.cc.lib  # libstdc++.so.6
      pkgs.sane-backends     # libsane.so.1
      pkgs.nss               # llibnss3.so
      pkgs.nspr              # libnspr4.so
    ];
  in ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}" \
      $out/opt/master-pdf-editor-5/masterpdfeditor5
  '';

  desktopItems = [ (pkgs.makeDesktopItem {
    name = "Master PDF editor HansRuedi";
    exec = "Master PDF editor HansRuedi";
    desktopName = "$out/bin/masterpdfeditor5";
    terminal = true;
  }) ];

  # pkgs.meta = with pkgs.lib; {
  #   homepage = https://code-industry.net/masterpdfeditor/;
  #   description = "a multifunctional PDF Editor";
  #   license = licenses.unfree;
  #   platforms = platforms.linux;
  #   maintainers = [ "Hans Peter Ruedi" ];
  # };
}
