{
  inputs,
  overlays,
  username,
  password,
}: system: let
  home-manager = import ../module/home-manager.nix {inherit inputs;};
  pkgs = inputs.nixpkgs.legacyPackages.${system};
  # sweet-cursors-theme = import ../module/themes/sweet-cursors-theme.nix {inherit pkgs;};
in
  inputs.nixpkgs.lib.nixosSystem {
    inherit system;

    # modules: allows for reusable code
    modules = [
      ../hardware-configuration.nix
      ../configuration.nix

      {nixpkgs.overlays = overlays;}

      {
        nixpkgs.config.allowUnfreePredicate = _: true;

        programs.fish.enable = true;

        environment = {
          localBinInPath = true;
          shells = [pkgs.fish];
          systemPackages = with pkgs; [
            alejandra
            awesome
            brave
            nautilus
            adwaita-icon-theme
            gnomeExtensions.appindicator
            mpv
            nsxiv
            nh
            unar
            unzip
            zip
            xclip
            xorg.xev
            xorg.xmodmap
            xdg-user-dirs
            xdg-utils
            xdg-launch
            usbutils
            gucharmap
            gphoto2
            v4l-utils
            linuxKernel.packages.linux_6_6.v4l2loopback
            # gphoto2fs
            # nautilus-python
            # xfce.xfce4-terminal
            libreoffice-qt6-fresh

            # C/C++ build tools
            gcc
            gnumake
            # libclang
            # clang-tools
            # cmake

            # Other build tools
            # pkgs.ninja
            # pkgs.meson

            (pkgs.writeShellScriptBin "remaps" ''
              ${pkgs.xorg.xmodmap}/bin/xmodmap -e "keycode 64 = Alt_L"
              ${pkgs.xorg.xmodmap}/bin/xmodmap -e "keycode 134 = Hyper_L"
              ${pkgs.xorg.xmodmap}/bin/xmodmap -e "remove mod4 = Hyper_L"
              ${pkgs.xorg.xmodmap}/bin/xmodmap -e "add mod3 = Hyper_L"
              xset r rate 200 40
            '')

            (pkgs.writeShellScriptBin "canonwbc" ''
              # Commands taken from:
              # https://maximevaillancourt.com/blog/canon-dslr-webcam-debian-ubuntu

              # sudo modprobe v4l2loopback

              vidsrc="video0"
              # gphoto2 --stdout --capture-movie | ffmpeg -i - -vcodec rawvideo -pix_fmt yuv420p -threads 0 -f v4l2 /dev/$vidsrc

              gphoto2 --stdout --capture-movie | ffmpeg -hwaccel nvdec -c:v mjpeg_cuvid -i - -vcodec rawvideo -pix_fmt yuv420p -threads 0 -f v4l2 /dev/$vidsrc


              # [ -z "$1" ] || vlc v4l2:///dev/$vidsrc
              #
              # # gphoto2 --stdout --capture-movie | ffmpeg -i - -vcodec rawvideo -pix_fmt yuv420p -threads 0 -f v4l2 /dev/$vidsrc


              # gphoto2 --stdout --capture-movie | ffmpeg -hwaccel nvdec -c:v mjpeg_cuvid -i - -vcodec rawvideo -pix_fmt yuv420p -threads 0 -f v4l2 /dev/$vidsrc
            '')

            vim
            inputs.ghostty.packages.x86_64-linux.default

            # fiji
          ];

          # sessionVariables.NAUTILUS_4_EXTENSION_DIR = "${pkgs.nautilus-python}/lib/nautilus/extensions-4";
          pathsToLink = [
            # "/share/nautilus-python/extensions"
            "/share/xdg-desktop-portal"
            "/share/applications"
          ];
        };

        # I think we should only need to enable these settings if we are trying
        # to run GNOME applications outside of a GNOME DE.
        programs.dconf.enable = true;

        # programs.nautilus-open-any-terminal = {
        #   enable = true;
        #   terminal = "ghostty";
        # };

        programs._1password.enable = true;
        programs._1password-gui = {
          enable = true;
          # Certain features, including CLI integration and system authentication support,
          # require enabling PolKit integration on some desktop environments (e.g. Plasma).
          polkitPolicyOwners = ["thegusbus"];
        };

        programs.obs-studio.enableVirtualCamera = true;

        fonts.packages = with pkgs; [
          cm_unicode
          jetbrains-mono
        ];
      }

      {
        # services.displayManager.autoLogin.user = username;
        boot.extraModulePackages = [pkgs.linuxPackages.v4l2loopback];

        services.gvfs.enable = true; # Mount, trash, and other functionalities

        services.xserver = {
          displayManager = {
            gdm = {
              enable = true;
              wayland = false;
            };
            # lightdm = {
            #   enable = true;
            #   greeters.gtk = {
            #     enable = true;
            #     # cursorTheme.name = "Sweet-cursors";
            #     # cursorTheme.package = sweet-cursors-theme;
            #     cursorTheme.size = 128;
            #   };
            # };
            sessionCommands = "remaps"; # "~/.local/bin/remaps";
          };

          excludePackages = with pkgs; [xterm];

          desktopManager = {
            xterm.enable = false;
            # xfce = {
            #   enable = true;
            #   noDesktop = true;
            #   enableXfwm = false;
            # };
            wallpaper.mode = "fill";
          };

          windowManager = {
            awesome.enable = true;
          };
        };

        services.displayManager.defaultSession = "none+awesome";

        # I think we should only need to enable these settings if we are trying to run GNOME applications outside of a GNOME DE?
        # Otherwise it looks like the nixos/nixpkgs/services/x11/desktop-managers/gnome.nix module sets all these things up for us by default when enabled.
        services.udev.packages = with pkgs; [gnome-settings-daemon];
        # services.dbus.packages = [];
        # services.dbus.enable = true;

        users.defaultUserShell = pkgs.fish;
        users.users."${username}" = {
          extraGroups = ["networkmanager" "wheel"];
          home = "/home/${username}";
          isNormalUser = true;
          password = password;
          shell = pkgs.fish;
        };
      }

      inputs.home-manager.nixosModules.home-manager
      {
        # add home-manager settings here
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users."${username}" = home-manager;
        home-manager.backupFileExtension = "backup";
      }

      # add more nix modules here

      inputs.nix-index-database.nixosModules.nix-index
    ];
  }
