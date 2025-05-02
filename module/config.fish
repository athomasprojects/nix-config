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


# Darwin rebuild
abbr drc "darwin-rebuild check --flake \".#aarch64\""
abbr drs "darwin-rebuild switch --flake \".#aarch64\""

# Creates and checks out a new branch
abbr gbn "git checkout -b"

# abbr wz "nvim $HOME/nix-config/module/wezterm/wezterm.lua" 
# abbr gst "nvim $HOME/nix-config/module/ghostty.mac"

# abbr gfy "$HOME/.config/yazi/yazirc"
# abbr gfX "$HOME/.config/nsxiv/exec/key-handler" 

#-------------------------------------------------------------------------------
# Functions
#-------------------------------------------------------------------------------
# Shortcut to setup a nix-shell with fish. This lets you do something like
# `fnix -p go` to get an environment with Go but use the fish shell along
# with it.
alias fnix "nix-shell --run fish"

function gfind --description 'Shows the path of a file or directory if it exists in a given branch (default current index and working tree)'
    set -l options h/help b/branch=
    argparse $options -- $argv
    or return

    if set -ql _flag_help
        echo "gfind [-h|--help] [-b|--branch=BRANCH] [NAME]"
        return 0
    end

    if test (count $argv) -eq 0
        echo "Error: missing required NAME argument" >&2
        echo "Run 'gfind --help' for usage." >&2
        return 1
    end

    if set -ql _flag_branch
        for name in $argv
            git ls-tree -r --name-only $_flag_branch | grep -i --color=always -- $name
        end
    else
        for name in $argv
            git ls-files | grep -i --color=always -- $name
        end
    end
end

function glf --description 'Shows which commits on a branch (default HEAD) changed a given file or directory'
    set -l options h/help b/branch=
        argparse --max-args=2 $options -- $argv
    or return

    if set -ql _flag_help
        echo "Usage: glf [-h|--help] [-b|--branch=BRANCH] [NAME]"
        return 0
    end

    if test (count $argv) -eq 0
        echo "Error: missing required NAME argument" >&2
        echo "Run 'glf --help' for usage." >&2
        return 1
    end


    if set -ql _flag_branch
        echo "== Commits from '$_flag_branch' that affected '$argv' =="
        git log --name-only --pretty=medium $_flag_branch -- $argv
    else
        echo "== Commits from HEAD that affected '$argv' =="
        git log --name-only --pretty=medium -- $argv
    end
end

function gg --description 'Searches for one or more substrings in all tracked files across either across all branches (default) or in a given branch'
    set -l options h/help b/branch=
    argparse $options -- $argv
    or return

    if set -ql _flag_help or 
        echo "gg [-h|--help] [-b|--branch=BRANCH] [PATTERN...]"
        return 0
    end

    if test (count $argv) -eq 0
        echo "Error: missing required PATTERN argument" >&2
        echo "Run 'gg --help' for usage." >&2
        return 1
    end

    if set -ql _flag_branch
        for pattern in $argv
            git grep -e $pattern $_flag_branch
            echo ""
        end
    else
        for pattern in $argv
            git grep -e $pattern
            echo ""
        end
    end
end
