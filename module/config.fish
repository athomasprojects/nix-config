# Add ~/.local/bin
set -q PATH; or set PATH ''; set -gx PATH  "$HOME/.local/bin" $PATH;

#-------------------------------------------------------------------------------
# Ghostty Shell Integration
#-------------------------------------------------------------------------------
# Ghostty supports auto-injection but Nix-darwin hard overwrites XDG_DATA_DIRS
# which make it so that we can't use the auto-injection. We have to source
# manually.
if set -q GHOSTTY_RESOURCES_DIR
    source "$GHOSTTY_RESOURCES_DIR/shell-integration/fish/vendor_conf.d/ghostty-shell-integration.fish"
end
# set -gx GDK_DISABLE gl-gles

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
set -gx TERMIAL ghostty

# Sourcegraph 
set -gx SRC_ENDPOINT "https://sourcegraph.com"
set -gx SRC_ACCESS_TOKEN (cat $HOME/.sg-access-token)

#-------------------------------------------------------------------------------
# Aliases
#-------------------------------------------------------------------------------
# Logging helpers
alias gls="git log --pretty=format:\"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]\" --decorate"
alias glx="git log --pretty=format:\"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]\" --decorate --numstat"
alias gdate="git log --pretty=format:\"%C(yellow)%h\\ %ad%Cred%d\\ %Creset%s%Cblue\\ [%cn]\" --decorate --date=relative"
alias gdatelong="git log --pretty=format:\"%C(yellow)%h\\ %ad%Cred%d\\ %Creset%s%Cblue\\ [%cn]\" --decorate --date=short"

# #alias gfy="$HOME/.config/yazi/yazirc"
# #alias gfX="$HOME/.config/nsxiv/exec/key-handler" 

#-------------------------------------------------------------------------------
# Abbreviations
#-------------------------------------------------------------------------------
# Trying out abbreviations for my commonly used shortcuts
abbr cac "cd $XDG_CACHE_HOME"
abbr cf "cd $XDG_CONFIG_HOME"
abbr cfn "cd $HOME/nix-config/module/nvim"
abbr dfz "cd $HOME/nix-config"
abbr lsh "cd $HOME/.local/share"
abbr lst "cd $HOME/.local/state"
abbr d "cd $HOME/Downloads"
abbr D "cd $HOME/Documents"
abbr pp "cd $HOME/Pictures"
abbr hbn "cd $HOME/bin"
abbr lbn "cd $HOME/.local/bin"
abbr c "cd $HOME/code"
abbr lt "cd $HOME/code/latexprojects"
abbr h "cd $HOME"
abbr ph "cd $HOME/Documents/phd"
abbr vv "cd $HOME/Videos"
# abbr mn "cd /mnt"
#alias ="cd vc  $HOME/Videos/screencasts"

# Shortcuts - files
abbr hm "cd $HOME/nix-config && nvim module/home-manager.nix" 
abbr fl "nvim $HOME/nix-config/flake.nix"					
abbr ns "nvim $HOME/nix-config/system/nixos.nix"					
abbr cfx "nvim $HOME/nix-config/module/Xresources" 
abbr cfs "nvim $HOME/nix-config/module/config.fish"
# abbr gst "nvim $HOME/nix-config/module/ghostty.linux" 
# abbr wz "nvim $HOME/nix-config/module/wezterm/wezterm.lua" 

# abbr gfy "$HOME/.config/yazi/yazirc"
# abbr gfX "$HOME/.config/nsxiv/exec/key-handler" 

#-------------------------------------------------------------------------------
# Functions
#-------------------------------------------------------------------------------
# Shortcut to setup a nix-shell with fish. This lets you do something like
# `fnix -p go` to get an environment with Go but use the fish shell along
# with it.
alias fnix "nix-shell --run fish"
