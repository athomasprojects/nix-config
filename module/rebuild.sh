#!/usr/bin/env bash
set -e
pushd "$DOTFILES"
nvim module/home-manager.nix
alejandra . &>/dev/null
git diff -U0 *.nix
echo "NixOS Rebuilding..."
sudo nixos-rebuild switch &>nixos-switch.log || (
 cat nixos-switch.log | grep --color error && false)
gen=$(nixos-rebuild list-generations | awk 'NR==3 { print $1, " current ", $2, $3,"", $4, "      ", $5 }')

git commit -am "$gen"
popd
