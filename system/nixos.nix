{ inputs, overlays, username, password }: system: 
let 
  	home-manager = import ../module/home-manager.nix { inherit inputs; };
  	pkgs = inputs.nixpkgs.legacyPackages.${system};
in
  inputs.nixpkgs.lib.nixosSystem {
    inherit system;

    # modules: allows for reusable code
    modules = [
      ./hardware-configuration.nix
      ../module/configuration.nix

      { nixpkgs.overlays = overlays; }

      { 
  	nixpkgs.config.allowUnfreePredicate = _: true;

  	programs.fish.enable = true;

	environment = {
          localBinInPath = true;
          shells = [ pkgs.fish ];
          systemPackages = with pkgs; [
	    pkgs.awesome
            brave
            # obs-studio
            # zoom-us
            mpv
            nix-index
            unar
            unzip
            zip
            xclip
            pkgs.xorg.xev
            pkgs.xorg.xmodmap
            pkgs.xdg-user-dirs
            pkgs.xdg-utils
            pkgs.xdg-launch

            vim
            # (rust-bin.selectLatestNightlyWith (toolchain: toolchain.default))
          ]; 
	};

  	programs.firefox.enable = true;

   	programs._1password.enable = true;
   	programs._1password-gui = {
   	  enable = true;
   	  # Certain features, including CLI integration and system authentication support,
   	  # require enabling PolKit integration on some desktop environments (e.g. Plasma).
   	  polkitPolicyOwners = [ "thegusbus" ];
   	};

      }

      {
        services.displayManager.autoLogin.user = username;

        # Use xfce desktop environment
  	# services.xserver.displayManager.lightdm.enable = true;
  	# services.xserver.desktopManager.xfce.enable = true;

	services.xserver = {
  	    displayManager = {
		lightdm.enable = true;
		sessionCommands = "~/.local/bin/remaps";
	    };

	    desktopManager = {
	        xterm.enable = false;
		wallpaper.mode = "fill";
	    };

	    windowManager = {
	    	awesome.enable = true;
	    };
	};

	services.displayManager.defaultSession = "none+awesome";

	users.defaultUserShell = pkgs.fish;
        users.users."${username}" = {
          extraGroups = [ "networkmanager" "wheel" ];
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
      }

      # add more nix modules here
    ];
  }
