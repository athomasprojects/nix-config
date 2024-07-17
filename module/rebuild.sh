#!/usr/bin/env bash
set -e
pushd "$DOTFILES"
nvim module/home-manager.nix
alejandra . &>/dev/null
git diff -U0 *.nix
echo "Nix-darwin Rebuilding..."
sudo darwin-rebuild switch --flake ./#x86_64 &>darwin-switch.log || (
 cat darwin-switch.log | grep --color error && false)
gen=$(darwin-rebuild list-generations | grep current)
git commit -am "$gen"
popd
