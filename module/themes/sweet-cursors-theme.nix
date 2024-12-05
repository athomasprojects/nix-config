{pkgs}:
pkgs.stdenv.mkDerivation {
  name = "Sweet-cursors";

  src = "${./Sweet-cursors.tar.xz}";

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share/icons
    tar -xf $src -C $out/share/icons
  '';
}
