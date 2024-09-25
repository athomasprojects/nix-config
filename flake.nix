{
  description = "Example kickstart NixOS desktop environment.";

  inputs = {
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
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

    plugin-ocaml-nvim.url = "github:tjdevries/ocaml.nvim";
    plugin-ocaml-nvim.flake = false;

    plugin-telescope-luasnip.url = "github:benfowler/telescope-luasnip.nvim";
    plugin-telescope-luasnip.flake = false;

    plugin-qf-helper.url = "github:stevearc/qf_helper.nvim";
    plugin-qf-helper.flake = false;
  };

  outputs = inputs @ {
    self,
    darwin,
    home-manager,
    nixpkgs,
    rust-overlay,
    alejandra,
    nix-index-database,
    ...
  }: let
    system = "aarch64-darwin";

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
    ];

    darwin-system = import ./system/darwin.nix {
      inherit inputs overlays;
      username = "amanda";
    };
  in {
    darwinConfigurations = {
      aarch64 = darwin-system system;
    };
  };
}
