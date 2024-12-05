#!/usr/bin/env bash
set -e
pushd "$DOTFILES"
nvim module/home-manager.nix
alejandra . &>/dev/null
git diff -U0 *.nix
echo "Nix-darwin Rebuilding..."
(darwin-rebuild switch --flake ".#aarch64") &>darwin-switch.log || (grep --color error darwin-switch.log && false)
gen=$(darwin-rebuild --list-generations | grep current)
git commit -am "$gen"
popd
