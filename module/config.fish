# Add ~/.local/bin
set -q PATH; or set PATH ''; set -gx PATH  "$HOME/.local/bin" $PATH;

#-------------------------------------------------------------------------------
# Prompt
#-------------------------------------------------------------------------------
# Do not show any greeting
set --universal --erase fish_greeting
# function fish_greeting; end
# funcsave fish_greeting

#-------------------------------------------------------------------------------
# Vars
#-------------------------------------------------------------------------------
# Modify our path to include our Go binaries
contains $HOME/code/go/bin $fish_user_paths; or set -Ua fish_user_paths $HOME/code/go/bin
contains $HOME/bin $fish_user_paths; or set -Ua fish_user_paths $HOME/bin

# Exported variables
# if isatty
#     set -x GPG_TTY (tty)
# end

# Editor
set -gx EDITOR nvim

#-------------------------------------------------------------------------------
# Aliases
#-------------------------------------------------------------------------------
# Logging helpers
alias gls="git log --pretty=format:\"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]\" --decorate"
alias gllx="git log --pretty=format:\"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]\" --decorate --numstat"
alias gdate="git log --pretty=format:\"%C(yellow)%h\\ %ad%Cred%d\\ %Creset%s%Cblue\\ [%cn]\" --decorate --date=relative"
alias gdatelong="git log --pretty=format:\"%C(yellow)%h\\ %ad%Cred%d\\ %Creset%s%Cblue\\ [%cn]\" --decorate --date=short"

# Shortcuts - directories
alias cac="cd $XDG_CACHE_HOME"
alias cfg="cd $XDG_CONFIG_HOME"
alias cfn="cd $HOME/nix-config/module/nvim"
alias cfs="cd $HOME/nix-config/module/config.fish"
alias cfk="cd $HOME/nix-config"
alias lsh="cd $HOME/.local/share"
alias d="cd $HOME/Downloads"
alias D="cd $HOME/Documents"
alias pp="cd $HOME/Pictures"
alias hbn="cd $HOME/bin"
alias lbn="cd $HOME/.local/bin"
alias c="cd $HOME/code"
alias lt="cd $HOME/code/latexprojects"
alias h="cd $HOME"
alias mn="cd  /mnt"
alias ph="cd  $HOME/Documents/phd"
alias vv="cd  $HOME/Videos"
#alias ="cd vc  $HOME/Videos/screencasts"

# Shortcuts - files
alias hm="nvim $HOME/nix-config/module/home-manager.nix" 
alias fl="nvim $HOME/nix-config/flake.nix"					
alias ns="nvim $HOME/nix-config/system/nixos.nix"					
alias cfx="nvim $HOME/nix-config/module/Xresources" 
alias wz="nvim $HOME/nix-config/module/wezterm/wezterm.lua" 

#alias ="gfy	$HOME/.config/yazi/yazirc	
#alias ="gfX	$HOME/.config/nsxiv/exec/key-handler" 

#-------------------------------------------------------------------------------
# Functions
#-------------------------------------------------------------------------------
# Shortcut to setup a nix-shell with fish. This lets you do something like
# `fnix -p go` to get an environment with Go but use the fish shell along
# with it.
alias fnix "nix-shell --run fish"
