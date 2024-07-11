{
  description = "Example kickstart NixOS desktop environment.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # flake-parts.url = "github:hercules-ci/flake-parts";

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    alejandra = {
      url = "github:kamadorueda/alejandra/3.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plugin-cmp-vimtex.url = "github:micangl/cmp-vimtex";
    plugin-cmp-vimtex.flake = false;

    plugin-express-line.url = "github:tjdevries/express_line.nvim";
    plugin-express-line.flake = false;

    plugin-edit-alternate.url = "github:tjdevries/edit_alternate.vim";
    plugin-edit-alternate.flake = false;

    plugin-standard-vim.url = "github:tjdevries/standard.vim";
    plugin-standard-vim.flake = false;

    plugin-conf-vim.url = "github:tjdevries/conf.vim";
    plugin-conf-vim.flake = false;

    plugin-ocaml-nvim.url = "github:tjdevries/ocaml.nvim";
    plugin-ocaml-nvim.flake = false;
  };

  outputs = inputs @ {
    self,
    home-manager,
    nixpkgs,
    rust-overlay,
    alejandra,
    ...
  }: let
    system = "x86_64-linux";

    overlays = [
      rust-overlay.overlays.default
      inputs.neovim-nightly-overlay.overlays.default
      (final: prev: {
        vimPlugins =
          prev.vimPlugins
          // {
            own-cmp-vimtex = prev.vimUtils.buildVimPlugin {
              name = "cmp-vimtex";
              src = inputs.plugin-cmp-vimtex;
            };
          };
      })
      (final: prev: {
        vimPlugins =
          prev.vimPlugins
          // {
            own-express-line = prev.vimUtils.buildVimPlugin {
              name = "express_line";
              src = inputs.plugin-express-line;
            };
          };
      })
      (final: prev: {
        vimPlugins =
          prev.vimPlugins
          // {
            own-edit-alternate = prev.vimUtils.buildVimPlugin {
              name = "edit_alternate";
              src = inputs.plugin-edit-alternate;
            };
          };
      })
      (final: prev: {
        vimPlugins =
          prev.vimPlugins
          // {
            own-standard-vim = prev.vimUtils.buildVimPlugin {
              name = "standard";
              src = inputs.plugin-standard-vim;
            };
          };
      })
      (final: prev: {
        vimPlugins =
          prev.vimPlugins
          // {
            own-conf-vim = prev.vimUtils.buildVimPlugin {
              name = "conf";
              src = inputs.plugin-conf-vim;
            };
          };
      })
      (final: prev: {
        vimPlugins =
          prev.vimPlugins
          // {
            own-ocaml-nvim = prev.vimUtils.buildVimPlugin {
              name = "ocaml";
              src = inputs.plugin-ocaml-nvim;
            };
          };
      })
    ];

    nixos-system = import ./system/nixos.nix {
      # specialArgs = {
      # 	pkgs-stable = import nixpkgs-stable {
      # 		inherit system;
      # 		config.allowUnfree = true;
      # 	};
      # 	inherit inputs system;
      # };

      inherit inputs overlays;
      username = "thegusbus"; # TODO: replace with user name and remove throw
      password = "neemo123"; # TODO: replace with password and remove throw
    };
  in {
    nixosConfigurations = {
      x86_64 = nixos-system system;
    };
  };
  #  flake-parts.lib.mkFlake { inherit inputs; } {
  #  	flake = {
  #    		nixosConfigurations = {
  #    		  x86_64 = nixos-system system;
  #    		};
  # };
  # systems = [ system ];
  #
  # # perSystem = { pkgs, ... }: {
  # #     formatter = pkgs.alejandra;
  # # };
  #  };
}
