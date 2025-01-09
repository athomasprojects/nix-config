# Note: This is derivation is taken from coosis' nixpkgs.
# I think we need to tweak some things during the install phase so that this works on my system.
# I will include this derivation in the commit history for now as a reference.
# See: https://github.com/Coosis/coosis-nix/blob/main/pkgs/codelldb/default.nix
{
  stdenv,
  lib,
  fetchurl,
  makeWrapper,
  unzip,
}:
# assert stdenv.isLinux || stdenv.isDarwin -> "Only Linux and Darwin are supported";
let
  version = "1.11.1";
  system = stdenv.system;
  binaries = {
    "x86_64-linux" = {
      url = "https://github.com/vadimcn/codelldb/releases/download/v${version}/codelldb-linux-x64.vsix";
      sha256 = "sha256-c8oVYihrJKHaHNM2uVBZnwSR+OtEfxYwtO/Qc9LMBlE=";
    };
    # Todo: Update rest of binary filenames in URLs for v1.11.1
    # "aarch64-linux" = {
    #   url = "https://github.com/vadimcn/codelldb/releases/download/v${version}/codelldb-aarch64-linux.vsix";
    #   sha256 = "";
    # };
    # "arm-linux" = {
    #   url = "https://github.com/vadimcn/codelldb/releases/download/v${version}/codelldb-arm-linux.vsix";
    #   sha256 = "";
    # };
    # "x86_64-darwin" = {
    #   url = "https://github.com/vadimcn/codelldb/releases/download/v${version}/codelldb-x86_64-darwin.vsix";
    #   sha256 = "";
    # };
    # "aarch64-darwin" = {
    #   url = "https://github.com/vadimcn/codelldb/releases/download/v${version}/codelldb-aarch64-darwin.vsix";
    #   sha256 = "";
    # };
  };
in
  stdenv.mkDerivation {
    pname = "codelldb";
    inherit version;

    nativeBuildInputs = [unzip makeWrapper];

    src = fetchurl {
      url = binaries.${system}.url;
      sha256 = binaries.${system}.sha256;
    };

    unpackPhase = ''
      mkdir -p $out/bin
      unzip $src -d $out
    '';

    installPhase = ''
      # ln -s $out/extension/adapter/codelldb $out/bin/codelldb
      # chmod +x $out/extension/adapter/codelldb
                              makeWrapper $out/extension/adapter/codelldb $out/bin/codelldb \
                              --set LD_LIBRARY_PATH $out/extension/lldb/lib \
                              --set DYLD_LIBRARY_PATH $out/extension/lldb/lib
                              chmod +x $out/bin/codelldb
    '';

    meta = {
      description = "CodeLLDB executable, solely for use with nvim-dap plugin of neovim";
      homepage = "https://github.com/vadimcn/vscode-lldb";
      license = lib.licenses.mit;
      platforms = lib.platforms.linux ++ lib.platforms.darwin;
    };
  }
