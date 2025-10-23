final: prev: let
  self = prev.sioyek;
in {
  sioyek = self.overrideAttrs (old: {
    # Entries in qtWrapperArgs modify the wrappers created by the
    # wrapQtAppsHook that builds the wrapper script that launches the app.
    #
    # Injecting the LD_LIBRARY_PATH and QT_QPA_PLATFORM environment variables
    # into the wrapper script that launches the sioyek binary resolves the
    # missing pipewire-0.3 symbols and `Failed to create QEGLPlatformContext:
    # 3009` errors that were preventing sioyek from opening a window.
    #
    # NOTE: See https://nixos.org/manual/nixpkgs/stable/#mkderivation-recursive-attributes
    # for more information about wrapQtAppsHook.
    #
    # The nixpkgs sioyek derivation does not link the pipewire shared library
    # (libpipewire-0.3.so.0), resulting in the missing pipewire-0.3 symbols
    # error. Adding pipewire to LD_LIBRARY_PATH fixes this.
    #
    # On Wayland we also run into the missing QEGLPlatformContext error,
    # preventing sioyek from opening a window. Running sioyek through xwayland
    # fixes this issue. To do this set QT_QPA_PLATFORM to xcb.
    # See:
    #   https://github.com/ahrm/sioyek/issues/1283#issuecomment-2622957318
    #   https://github.com/ahrm/sioyek/issues/1283#issuecomment-3012097149

    qtWrapperArgs =
      (old.qtWrapperArgs or [])
      ++ final.lib.optionals final.stdenv.hostPlatform.isLinux [
        "--set QT_QPA_PLATFORM xcb"
        "--prefix LD_LIBRARY_PATH : ${final.lib.makeLibraryPath [final.pipewire]}"
      ];
  });
}
