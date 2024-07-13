{inputs}: {
  pkgs,
  config,
  ...
}: let
  onePassPath = "~/.1password/agent.sock";
  my-harpoon2 = pkgs.vimUtils.buildVimPlugin {
    name = "harpoon2";
    src = pkgs.fetchFromGitHub {
      owner = "ThePrimeagen";
      repo = "harpoon";
      rev = "0378a6c428a0bed6a2781d459d7943843f374bce";
      sha256 = "sha256-FZQH38E02HuRPIPAog/nWM55FuBxKp8AyrEldFkoLYk=";
    };
  };
in {
  # -------------------------------------------------------------------
  # Packages
  # -------------------------------------------------------------------
  home.packages = [
    pkgs.ncpamixer
    pkgs.atuin
    pkgs.btop
    pkgs.obsidian
    pkgs.obs-studio
    pkgs.discord
    pkgs.bat
    pkgs.neofetch
    pkgs.delta
    pkgs.flameshot
    pkgs.fd
    pkgs.file
    pkgs.fzf
    pkgs.ripgrep
    pkgs.jq
    pkgs.nodejs
    pkgs.tree
    pkgs.eza
    pkgs.ffmpeg
    pkgs.ffmpegthumbnailer
    pkgs.poppler
    pkgs.git
    pkgs.manix
    # pkgs.texlive
    # pkgs.uv
    # pkgs.rye
    pkgs.sioyek
    pkgs.src-cli
    pkgs.tokei
    pkgs.starship
    pkgs.wezterm
    pkgs.yazi
    pkgs.zoxide
    pkgs.valgrind
  ];

  home.stateVersion = "24.11";

  xdg.enable = true;

  fonts.fontconfig.enable = true;

  home.sessionVariables = {
    LANG = "en_CA.UTF-8";
    LC_TYPE = "en_CA.UTF-8";
    LC_ALL = "en_CA.UTF-8";
    EDITOR = "nvim";
    MANPAGER = "nvim +Man!";
    TERMINAL = "wezterm";
    TERMINAL_PROG = "wezterm";
    BROWSER = "brave";
    DOTFILES = "$HOME/nix-config";
    PAGER = "less -FirSwX";
    # Less pager
    # LESS_TERMCAP_mb="$(printf '%b' '[1;31m')";
    # LESS_TERMCAP_md="$(printf '%b' '[1;36m')";
    # LESS_TERMCAP_me="$(printf '%b' '[0m')";
    # LESS_TERMCAP_so="$(printf '%b' '[01;44;33m')";
    # LESS_TERMCAP_se="$(printf '%b' '[0m')";
    # LESS_TERMCAP_us="$(printf '%b' '[1;32m')";
    # LESS_TERMCAP_ue="$(printf '%b' '[0m')";
    # LESSOPEN="| /usr/bin/highlight -O ansi %s 2>/dev/null";
  };

  home.file.".inputrc".source = ./inputrc;

  programs.fish = {
    enable = true;
    interactiveShellInit = pkgs.lib.strings.concatStrings (pkgs.lib.strings.intersperse "\n" [
      "set fish_greeting"
      (builtins.readFile ./config.fish)
      "set -g SHELL ${pkgs.fish}/bin/fish"
    ]);
    shellAliases = {
      gs = "git status";
      gsh = "git show";
      gco = "git checkout";
      gpull = "git pull";
      gpush = "git push";
      gd = "git diff";
      gdh = "git diff HEAD";
      gpr = "git pull --rebase";

      # Adding helpers
      gadd = "git add .";
      gca = "git add . && git commit -av";

      # Branch helpers
      gout = "git checkout";

      gfind = "git ls-files | grep -i";

      # Switching contexts
      gwip = ''git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit -m "[WIP]: $(date)"'';
      gnotes = ''git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit -m "[NOTES]: $(date)"'';

      # Oops savers
      gundo = "git reset HEAD~";

      pbcopy = "xclip";
      pbpaste = "xclip -o";

      ls = "ls -F --color=auto --group-directories-first --sort=version";
      ldr = "ls --color --group-directories-first";
      ldl = "ls --color -l --group-directories-first";
      ll = "ls -al";
      la = "ls -A";
      l = "ls -CF";

      # This is GOLD for finding out what is taking so much space on your drives!
      diskspace = "du -S | sort -n -r |more";

      # Show me the size (sorted) of only the folders in this directory
      folders = "find . -maxdepth 1 -type d -print | xargs du -sk | sort -rn";

      xsc = "xclip -r -selection clipboard";
      cp = "cp -iv";
      mv = "mv -iv";
      rm = "rm -vI";
      mkd = "mkdir -pv";

      ffmpeg = "ffmpeg -hide_banner";

      es = "eza --time-style=long-iso --group-directories-first --no-permissions --no-user";
      esa = "eza --all --time-style=long-iso --group-directories-first --no-permissions --no-user";
      est = "eza --tree --time-style=long-iso --group-directories-first --no-permissions --no-user";

      my_ip = "ip address | grep -o \"inet 192.*/\" | awk '{ print \$2 }' | tr / ' ' | xargs";
      my_eip = "curl ifconfig.co";

      ref = "~/.local/bin/shortcuts >/dev/null; source ${config.xdg.configHome}/shell/shortcutrc ; source ${config.xdg.configHome}/shell/zshnameddirrc";

      # prepcam="sudo modprobe v4l2loopback && pkill gphoto";
      # dslrcam="canonwbc";
    };

    functions = {
      gbn = {
        body = "git checkout -b $argv[1]";
      };
    };

    plugins =
      map (n: {
        name = n;
        src = pkgs.fishPlugins.${n}.src;
      }) [
        "fzf-fish"
        "z"
      ];
  };

  programs.direnv = {
    enable = true;
    # config = {
    #   exact = [ "$HOME/.envrc" ];
    # };
  };

  programs.eza = {
    enableFishIntegration = false;
  };

  programs.atuin = {
    enable = true;
    flags = [
      "--disable-up-arrow"
    ];
  };

  programs.starship = {
    enable = true;
    settings = {
      gcloud = {
        disabled = true;
      };
    };
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "Sublime Snazzy";
    };
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
          IdentityAgent ${onePassPath}
    '';
  };

  programs.git = {
    enable = true;
    userEmail = "amanda.thomas14@gmail.com";
    userName = "athomasprojects";
    aliases = {
      lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative";
    };
    delta = {
      enable = true;
      options = {
        line-numbers = true;
        syntax-theme = "Sublime Snazzy";
        side-by-side = false;
        file-modified-label = "modified:";
      };
    };
    extraConfig = {
      gpg = {
        format = "ssh";
      };
      "gpg \"ssh\"" = {
        program = "${pkgs.lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
      };
      commit = {
        gpgsign = true;
      };

      user = {
        signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAo7MRrDY9I4IDpUSz3IsjaAwONhEArRqJhsq6bXRKqQ";
      };
    };
  };

  # xdg.configFile = {
  #     nvim = {
  #       source = config.lib.file.mkOutOfStoreSymlink ../config/nvim;
  #       recursive = true;
  #     };
  # };

  programs.neovim = let
    # toLua = str: "lua << EOF\n${str}\nEOF\n";
    toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
  in {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
    defaultEditor = true;
    extraPackages = [
      pkgs.cmake
      pkgs.luajitPackages.jsregexp
      pkgs.xclip

      # Latex
      pkgs.texliveFull

      # Linter
      pkgs.stylua
      pkgs.ruff

      # LSP
      pkgs.clang-tools
      pkgs.clang
      pkgs.lua-language-server
      pkgs.bash-language-server
      pkgs.ocamlPackages.ocaml-lsp
      (pkgs.rust-bin.selectLatestNightlyWith (toolchain: toolchain.default))
      pkgs.nil
      pkgs.pyright
      pkgs.ruff-lsp
      pkgs.yaml-language-server
      pkgs.nodePackages_latest.vscode-json-languageserver

      # TODO: add texlive lualatex or pdflatex pkgs so that vimtex can access the compiler
    ];

    extraLuaConfig = ''
      ${builtins.readFile ./nvim/options.lua}
      ${builtins.readFile ./nvim/keymaps.lua}
      ${builtins.readFile ./nvim/terminal.lua}
      ${builtins.readFile ./nvim/spell.lua}
      ${builtins.readFile ./nvim/ftypes.lua}
    '';

    extraConfig = ''
      ${builtins.readFile ./nvim/menu.vim}
      ${builtins.readFile ./nvim/auft.vim}
    '';

    plugins = with pkgs.vimPlugins; [
      vim-nix
      plenary-nvim
      nvim-web-devicons
      fidget-nvim
      {
        plugin = undotree;
        config = toLuaFile ./nvim/plugin/undotree.lua;
      }
      {
        plugin = colorbuddy-nvim;
        config = toLuaFile ./nvim/plugin/colorscheme.lua;
      }

      {
        plugin = pkgs.vimPlugins.own-express-line;
        config = toLuaFile ./nvim/plugin/statusline.lua;
      }

      {
        plugin = oil-nvim;
        config = toLuaFile ./nvim/plugin/oil.lua;
      }

      {
        plugin = mini-nvim;
        config = toLuaFile ./nvim/plugin/mini.lua;
      }

      sqlite-lua
      telescope-fzf-native-nvim
      telescope-smart-history-nvim
      telescope-ui-select-nvim
      telescope-manix
      {
        plugin = telescope-nvim;
        config = toLuaFile ./nvim/plugin/telescope.lua;
      }

      {
        plugin = luasnip;
        config = toLuaFile ./nvim/plugin/snippets.lua;
      }

      vim-dadbod
      vim-dadbod-completion
      vim-dadbod-ui

      lspkind-nvim
      cmp-path
      cmp-buffer
      cmp_luasnip
      cmp-nvim-lsp
      {
        plugin = nvim-cmp;
        config = toLuaFile ./nvim/plugin/completion.lua;
      }
      pkgs.vimPlugins.own-cmp-vimtex

      {
        plugin = sg-nvim;
        config = toLuaFile ./nvim/plugin/sourcegraph.lua;
      }

      {
        plugin = vimtex;
        config = toLuaFile ./nvim/plugin/vimtex.lua;
      }

      {
        plugin = zen-mode-nvim;
        config = toLuaFile ./nvim/plugin/zenmode.lua;
      }

      pkgs.vimPlugins.own-standard-vim
      pkgs.vimPlugins.own-conf-vim
      {
        plugin = pkgs.vimPlugins.own-edit-alternate;
        config = toLuaFile ./nvim/plugin/edit_alternate.lua;
      }

      {
        plugin = my-harpoon2;
        config = toLuaFile ./nvim/plugin/hrpn.lua;
      }

      {
        plugin = nvim-lspconfig;
        config = toLuaFile ./nvim/plugin/lsp.lua;
      }
      lsp_lines-nvim
      neodev-nvim
      conform-nvim
      SchemaStore-nvim

      pkgs.vimPlugins.own-ocaml-nvim

      # nvim-dap
      # nvim-dap-ui
      # nvim-dap-python
      # nvim-dap-virtual-text
      # Need to load these separately (fetch from Github)
      # telescope-luasnip

      nvim-treesitter-textobjects
      {
        plugin = nvim-treesitter.withPlugins (p: [
          # p.tree-sitter-lua
          p.tree-sitter-bash
          p.tree-sitter-bibtex
          p.tree-sitter-devicetree
          p.tree-sitter-fish
          p.tree-sitter-go
          p.tree-sitter-html
          p.tree-sitter-javascript
          p.tree-sitter-json
          p.tree-sitter-latex
          p.tree-sitter-make
          p.tree-sitter-nix
          p.tree-sitter-ocaml
          p.tree-sitter-ocaml-interface
          p.tree-sitter-ocamllex
          p.tree-sitter-python
          p.tree-sitter-rust
          p.tree-sitter-toml
          p.tree-sitter-vim
          p.tree-sitter-yaml
        ]);
        config = toLuaFile ./nvim/plugin/treesitter.lua;
      }
    ];
    withPython3 = true;
    withNodeJs = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  programs.zoxide = {
    enable = true;
  };

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.ncmpcpp = {
    enable = true;
  };

  programs.nix-index = {
    enable = true;
    # comma.enable = true;
  };

  xresources.extraConfig = builtins.readFile ./Xresources;

  home.pointerCursor = {
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    size = 128;
    x11.enable = true;
  };

  xdg.configFile = {
    wezterm = {
      source = config.lib.file.mkOutOfStoreSymlink ./wezterm;
      recursive = true;
    };
  };

  # xdg.configFile = {
  #     awesome = {
  #       source = config.lib.file.mkOutOfStoreSymlink ./awesome;
  #       recursive = true;
  #     };
  # };

  xsession.windowManager.awesome = {
    enable = true;
    package = pkgs.awesome;
    luaModules = with pkgs.luaPackages; [luarocks luadbi-mysql];
  };
}
