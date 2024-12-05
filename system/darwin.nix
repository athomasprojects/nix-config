{
  inputs,
  overlays,
  username,
}: system: let
  home-manager = import ../module/home-manager.nix {inherit inputs;};
  pkgs = inputs.nixpkgs.legacyPackages.${system};
in
  inputs.darwin.lib.darwinSystem {
    inherit system;

    # modules: allows for reusable code
    modules = [
      ../module/configuration.nix

      {nixpkgs.overlays = overlays;}

      {
        nixpkgs.config.allowUnfreePredicate = _: true;

        programs.fish.enable = true;
        programs.zsh.enable = true;

        environment = {
          systemPath = ["~/.local/bin"];
          shells = [pkgs.fish pkgs.zsh];
          loginShell = pkgs.fish;
          systemPackages = with pkgs; [
            alejandra
            cmake
            ninja
            gcc
            nh
            gnused
            unar
            unzip
            zip
            xclip
            vim
            xdg-user-dirs
            xdg-utils
            coreutils
            findutils
          ];
        };
      }

      {
        services.nix-daemon.enable = true;

        users.users."${username}" = {
          home = "/Users/${username}";
          shell = pkgs.fish;
        };
      }

      inputs.home-manager.darwinModules.home-manager
      {
        # add home-manager settings here
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users."${username}" = home-manager;
      }

      # add more nix modules here
      inputs.nix-index-database.darwinModules.nix-index
    ];
  }
