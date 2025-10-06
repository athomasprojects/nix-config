#!/usr/bin/env bash
set -euo pipefail

# Go to your dotfiles directory
pushd "$DOTFILES"

# Open home-manager config in terminal if inside a terminal
if [ -t 1 ]; then
    nvim module/home-manager.nix
fi

# Only run alejandra if a graphical session is available
if [ -n "${WAYLAND_DISPLAY-}" ] || [ -n "${DISPLAY-}" ]; then
    # Run in background but don't fail the script if it errors
    alejandra . &>/dev/null || true
fi

# Show git diff of Nix files
git diff -U0 -- *.nix || true


echo "Starting NixOS rebuild..."
LOG="nixos-switch.log"

# Try to use sudo without password first
if sudo -n true 2>/dev/null; then
    echo "Using passwordless sudo..."
else
    echo "Sudo requires a password. Please enter it:"
    # Prompt the user for their sudo password
    if ! sudo -v; then
        echo "Authentication failed. Exiting."
        exit 1
    fi
fi

# Run nixos-rebuild with sudo, preserving env vars
if ! sudo nixos-rebuild switch 2>&1 | tee "$LOG"; then
    echo "Rebuild failed. Showing errors:"
    grep --color=always -i error "$LOG" || true
    exit 1
fi

# Get the current generation info for commit message
GEN=$(nixos-rebuild list-generations | awk 'NR==3 { print $1, " current ", $2, $3,"", $4, "      ", $5 }')

# Stage only tracked Nix files that changed
git add -u '*.nix'

# Commit only if there are staged changes
if ! git diff --cached --quiet; then
    git commit -m "$GEN"
    echo "Changes committed."
else
    echo "No changes to commit."
fi

popd
