{inputs}: {
  pkgs,
  config,
  ...
}: let
  onePassPath = "~/.1password/agent.sock";
  tex = pkgs.texlive.combined.scheme-full;
  sweet-cursors-theme = import ./themes/sweet-cursors-theme.nix {inherit pkgs;};
  pointer_cursor_size = 128;
  gtk_cursor_size = "gtk-cursor-theme-size=${builtins.toString pointer_cursor_size}";
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
    pkgs.inkscape-with-extensions
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
    pkgs.sioyek
    pkgs.src-cli
    # tex
    pkgs.tokei
    pkgs.starship
    # pkgs.wezterm
    pkgs.yazi
    pkgs.zoxide
    pkgs.valgrind
    pkgs.ruff
  ];

  home.stateVersion = "24.11";

  xdg = {
    enable = true;
    mime = {
      enable = true;
    };
    mimeApps = {
      enable = true;
      associations.added = {
        "text/x-shellscript" = ["text.desktop"];
        "text/plain" = ["text.desktop"];
        "application/pdf" = ["sioyek.desktop"];
        "image/png" = ["img.desktop"];
        "image/jpeg" = ["img.desktop"];
        "image/gif" = ["img.desktop"];
      };
      defaultApplications = {
        "text/x-shellscript" = ["text.desktop"];
        "text/plain" = ["text.desktop"];
        "application/pdf" = ["sioyek.desktop"];
        "image/png" = ["img.desktop"];
        "image/jpeg" = ["img.desktop"];
        "image/gif" = ["img.desktop"];
      };
    };
    desktopEntries = {
      text = {
        name = "Text editor";
        type = "Application";
        exec = "ghostty -e nvim %U";
      };
      img = {
        name = "Image viewer";
        type = "Application";
        exec = "nsxiv -a %f";
      };
    };
  };

  fonts.fontconfig.enable = true;

  home.sessionVariables = {
    LANG = "en_CA.UTF-8";
    LC_TYPE = "en_CA.UTF-8";
    LC_ALL = "en_CA.UTF-8";
    EDITOR = "nvim";
    VISUAL = "nvim";
    MANPAGER = "nvim +Man!";
    TERMINAL = "ghostty";
    TERMINAL_PROG = "ghostty";
    # TERMINFO_DIRS = "${/etc/profiles/per-user/thegusbus/share/terminfo}";
    # TERM = "ghostty";
    BROWSER = "brave";
    DOTFILES = "$HOME/nix-config";
    PAGER = "less -FirSwX";
  };

  home.file.".inputrc".source = ./inputrc;

  xdg.configFile = {
    "ghostty/config".text = builtins.readFile ./ghostty.linux;
  };

  # xdg.configFile = {
  #   wezterm = {
  #     source = config.lib.file.mkOutOfStoreSymlink ./wezterm;
  #     recursive = true;
  #   };
  # };

  home.file."${config.xdg.configHome}/awesome/rc.lua".source = config.lib.file.mkOutOfStoreSymlink ./awesome/rc.lua;

  # xdg.configFile = {
  #     awesome = {
  #       source = config.lib.file.mkOutOfStoreSymlink ./awesome;
  #       recursive = true;
  #     };
  # };

  # TODO: Sioyek isn't using Berkeley mono font for some reason.
  xdg.configFile = {
    sioyek = {
      source = config.lib.file.mkOutOfStoreSymlink ./sioyek;
      recursive = true;
    };
  };

  programs.sioyek.enable = true;

  programs.bash.enable = true;

  programs.fish = {
    enable = true;
    interactiveShellInit = pkgs.lib.strings.concatStrings (pkgs.lib.strings.intersperse "\n" [
      "set fish_greeting"
      (builtins.readFile ./config.fish)
      "set -g SHELL ${pkgs.fish}/bin/fish"
      # "set -gx SSH_AUTH_SOCK ${onePassPath}"
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
      theme = "ansi"; #"Sublime Snazzy";
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
        syntax-theme = "ansi"; # "Sublime Snazzy";
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
  #
  # home.file."${config.xdg.configHome}/nvim/spell/en.utf-8.add".source = ./en.utf-8.add;
  # home.file."${config.xdg.configHome}/nvim/spell/en.utf-8.add.spl".source = ./en.utf-8.add.spl;

  home.file.".latexmkrc".source = config.lib.file.mkOutOfStoreSymlink ./latexmkrc;

  home.file."${config.xdg.configHome}/nvim/after/ftplugin" = {
    source = config.lib.file.mkOutOfStoreSymlink ./nvim/after/ftplugin;
    recursive = true;
  };
  home.file."${config.xdg.configHome}/nvim/lua" = {
    source = config.lib.file.mkOutOfStoreSymlink ./nvim/lua;
    recursive = true;
  };
  # home.file."${config.xdg.configHome}/nvim/queries" = {
  #   source = config.lib.file.mkOutOfStoreSymlink ./nvim/queries;
  #   recursive = true;
  # };

  programs.neovim = let
    # toLua = str: "lua << EOF\n${str}\nEOF\n";
    toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
  in {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
    defaultEditor = true;
    extraPackages = [
      pkgs.luajitPackages.jsregexp
      pkgs.xclip
      pkgs.ripgrep

      # Latex
      tex

      # Formatters
      inputs.alejandra.defaultPackage.${pkgs.system}
      pkgs.stylua

      # Linters
      pkgs.ruff

      # LSPs
      inputs.odin-overlay.packages.${pkgs.system}.ols
      pkgs.zls
      pkgs.clang-tools
      pkgs.vim-language-server
      pkgs.lua-language-server
      pkgs.bash-language-server

      # Todo: need to pass dune developer preview to neovim
      # inputs.ocaml-overlay.legacyPackages.${pkgs.system}.ocaml-ng.ocamlPackages.dune-dev
      pkgs.ocamlPackages.ocaml-lsp

      (pkgs.rust-bin.selectLatestNightlyWith (toolchain: toolchain.default))
      pkgs.nil
      pkgs.pyright
      pkgs.ruff-lsp
      pkgs.yaml-language-server
      pkgs.nodePackages_latest.vscode-json-languageserver

      # Debuggers
      pkgs.vscode-extensions.vadimcn.vscode-lldb
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
    '';

    plugins = with pkgs.vimPlugins; [
      vim-nix
      plenary-nvim
      nvim-web-devicons
      {
        plugin = nvim-nonicons;
        config = toLuaFile ./nvim/plugin/fonts.lua;
      }
      fidget-nvim
      {
        plugin = undotree;
        config = toLuaFile ./nvim/plugin/undotree.lua;
      }
      {
        plugin = nvim-colorizer-lua;
        config = toLuaFile ./nvim/plugin/colours.lua;
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
      pkgs.vimPlugins.own-telescope-luasnip
      {
        plugin = telescope-nvim;
        config = toLuaFile ./nvim/lua/telescope.lua;
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
      pkgs.vimPlugins.own-cmp-vimtex
      {
        plugin = nvim-cmp;
        config = toLuaFile ./nvim/plugin/completion.lua;
      }

      {
        plugin = sg-nvim;
        config = toLuaFile ./nvim/plugin/sourcegraph.lua;
      }

      {
        plugin = pkgs.vimPlugins.own-vimtex;
        # config = toLua ''
        #   ${builtins.readFile ./nvim/plugin/vimtex.lua}
        #   vim.g.vimtex_view_sioyek_exe = "${pkgs.sioyek}/bin/sioyek"
        #   vim.g.vimtex_callback_progpath= "${inputs.neovim-nightly-overlay.packages.${pkgs.system}.default}/bin/sh"
        # '';
        config = toLuaFile ./nvim/plugin/vimtex.lua;
      }

      {
        plugin = twilight-nvim;
        config = toLuaFile ./nvim/plugin/twilight.lua;
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
        # plugin = my-harpoon2;
        plugin = pkgs.vimPlugins.harpoon2;
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

      # pkgs.vimPlugins.own-ocaml-nvim

      # {
      #   plugin = nvim-bqf;
      #   config = toLuaFile ./nvim/plugin/nvim_bqf.lua;
      # }
      {
        plugin = pkgs.vimPlugins.own-qf-helper;
        config = toLuaFile ./nvim/plugin/qf_helper.lua;
      }

      {
        plugin = nvim-dap;
        # Note: We most likely don't need to do this anymore since we are using the codelldb binary that we packaged ourselves.
        config = let
          str = ''
            dap.adapters.codelldb = {
              type = 'server',
              port = "''${port}",
              executable = {
                command = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb",
                args = {"--port", "''${port}"},

                -- On windows you may have to uncomment this:
                -- detached = false,
              }
            }
          '';
        in "lua << EOF\n${builtins.readFile ./nvim/plugin/dap.lua}\n\n${str}\nEOF\n";
      }
      own-nvim-dap-nio
      nvim-dap-ui
      nvim-dap-python
      nvim-dap-virtual-text

      # nvim-treesitter-textobjects
      {
        plugin = nvim-treesitter.withPlugins (plugins:
          with plugins; [
            # p.tree-sitter-lua
            bash
            bibtex
            devicetree
            fish
            go
            html
            javascript
            json
            # latex
            make
            nix
            ocaml
            ocaml-interface
            ocamllex
            python
            rust
            toml
            vim
            yaml
            odin
            zig
          ]);
        config = toLuaFile ./nvim/plugin/treesitter.lua;
      }
    ];

    extraPython3Packages = pyPkgs: with pyPkgs; [debugpy];
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

  gtk = {
    enable = true;
    theme = {
      package = pkgs.arc-theme;
      name = "Arc-Darker";
    };
    cursorTheme = {
      package = sweet-cursors-theme;
      name = "Sweet-cursors";
    };
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
    gtk2.extraConfig = gtk_cursor_size;
  };

  home.pointerCursor = {
    name = "Sweet-cursors";
    package = sweet-cursors-theme;
    size = pointer_cursor_size;
    x11.enable = true;
    gtk.enable = true;
  };

  xresources.extraConfig = builtins.readFile ./Xresources;

  xsession.windowManager.awesome = {
    enable = true;
    package = pkgs.awesome;
    luaModules = with pkgs.luaPackages; [luarocks luadbi-mysql];
  };
}
