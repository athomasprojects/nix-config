{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source, here using the nixos-24.11 branch
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    alejandra = {
      url = "github:kamadorueda/alejandra/3.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ocaml-overlay = {
    #   url = "github:nix-ocaml/nix-overlays";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    odin-overlay.url = "github:kilzm/odin-overlay";

    ghostty = {
      url = "git+ssh://git@github.com/ghostty-org/ghostty";

      # NOTE: The below 2 lines are only required on nixos-unstable,
      # if you're on stable, they may break your build
      inputs.nixpkgs-stable.follows = "nixpkgs";
      inputs.nixpkgs-unstable.follows = "nixpkgs";
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

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

    # plugin-ocaml-nvim.url = "github:tjdevries/ocaml.nvim";
    # plugin-ocaml-nvim.flake = false;

    plugin-telescope-luasnip.url = "github:benfowler/telescope-luasnip.nvim";
    plugin-telescope-luasnip.flake = false;

    plugin-qf-helper.url = "github:stevearc/qf_helper.nvim";
    plugin-qf-helper.flake = false;

    plugin-vimtex.url = "github:lervag/vimtex";
    plugin-vimtex.flake = false;

    plugin-nvim-dap-nio.url = "github:nvim-neotest/nvim-nio";
    plugin-nvim-dap-nio.flake = false;
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    alejandra,
    rust-overlay,
    nix-index-database,
    ghostty,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    overlays = [
      (import ./overlays/sioyek.nix)
      # (import ./overlays/fiji.nix)
      rust-overlay.overlays.default
      inputs.odin-overlay.overlays.default
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
            own-vimtex = prev.vimUtils.buildVimPlugin {
              name = "vimtex";
              src = inputs.plugin-vimtex;
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
            own-telescope-luasnip = prev.vimUtils.buildVimPlugin {
              name = "telescope-luasnip";
              src = inputs.plugin-telescope-luasnip;
            };
          };
      })
      (final: prev: {
        vimPlugins =
          prev.vimPlugins
          // {
            own-qf-helper = prev.vimUtils.buildVimPlugin {
              name = "qf_helper";
              src = inputs.plugin-qf-helper;
            };
          };
      })
      (final: prev: {
        vimPlugins =
          prev.vimPlugins
          // {
            own-nvim-dap-nio = prev.vimUtils.buildVimPlugin {
              name = "nio";
              src = inputs.plugin-nvim-dap-nio;
            };
          };
      })
      # (final: prev: {
      #   vimPlugins =
      #     prev.vimPlugins
      #     // {
      #       own-ocaml-nvim = prev.vimUtils.buildVimPlugin {
      #         name = "ocaml";
      #         src = inputs.plugin-ocaml-nvim;
      #       };
      #     };
      # })
    ];

    nixos-system = import ./system/nixos.nix {
      # specialArgs = {
      # 	pkgs-stable = import inputs.nixpkgs-stable {
      # 		inherit system;
      # 		config.allowUnfree = true;
      # 	};
      # 	inherit inputs overlays;
      # };
      inherit inputs overlays;
      username = "thegusbus";
      password = "neemo123";
    };
  in {
    nixosConfigurations = {
      nixos = nixos-system system;
    };
  };
}
