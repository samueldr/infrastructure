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

#
# RabbitMQ
# --------
#

_mqctl() {
	RABBITMQ_USE_LONGNAME=true HOME=/var/lib/rabbitmq rabbitmqctl "$@"
}

vhost="ofborg"

# Creates admin user...
(
_mqctl add_user admin admin || :
_mqctl set_user_tags admin administrator
_mqctl set_permissions -p / admin ".*" ".*" ".*"
) || :

# Creates the vhost...
(
_mqctl add_vhost "$vhost"
) || :

# TODO : configure ACL like rabbitmq.tf does.
create_user() {
	user="$1"

	_mqctl add_user "$user" "$user" || :
	_mqctl set_permissions -p "$vhost" "$user" ".*" ".*" ".*"
}

create_user "management"
create_user "monitoring"
create_user "webhook"
create_user "ofborgservice"
create_user "logviewer"
