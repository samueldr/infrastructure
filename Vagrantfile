# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
	config.vm.box = "nixos/nixos-18.03-x86_64"

	#
	# All the ports needed for outside use.
	#

	# Web
	config.vm.network "forwarded_port", guest: 80, host: 8080

	# rabbitmq (?)
	[
		5671,
		5672,
		15671,
		15672,
		15674,
		25672,
		4369,
	].each do |p|
		config.vm.network "forwarded_port", guest: p, host: p
	end

	#
	# Shared folders
	#

	# Shares the parent folder as `/repos`.
	config.vm.synced_folder "../", "/repos"

	# Configures virtualbox provider.
	config.vm.provider "virtualbox" do |vb|
		# Customize the amount of memory on the VM:
		# FIXME: detect host memory and heuristically change.
		vb.memory = "2048"
	end

	# Cheaty way to "provision" using nixos-rebuild...
	# Unclean, but it's a development setup.
	# !!! THIS CLASHES WITH NIXOS VAGRANT PLUGIN.
	config.vm.provision(
		"shell",
		keep_color: true,
		run: "always",
		inline: <<~SHELL
		bash /vagrant/development/provision.sh
		SHELL
	)
end
