#!/usr/bin/env bash

PS4=" → "
set -eux

cat > /etc/nixos/vagrant.nix <<EOF
# This file is overwritten by the provisionner.
{ config, pkgs, ... }:
{
  imports = [
	./vagrant-hostname.nix
	./vagrant-network.nix
	/vagrant/development/default.nix
  ];
}
EOF

cd /vagrant/

# In a deviously hideous way, we enter the shell, to get the same exact
# nix path that would be defined for deployment use.
# Then, we run nixos-rebuild switch *using the global configuration.nix*.
# which includes the vagrant bits in which we are overriding a small bit.
nix-shell --run "NIX_PATH='$NIX_PATH:nix-config=/etc/nixos/configuration.nix' sudo nixos-rebuild switch --show-trace"
