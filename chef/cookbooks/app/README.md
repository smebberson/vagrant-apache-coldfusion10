vagrant-apache-coldfusion10 Cookbook
====================================

This is a simple cookbook for customising an Apache 2.2 ColdFusion 10 Vagrant vm.

At present it:

	* installs Ubuntu 12.04LTS
	* installs Java
	* installs Apache 2.2
	* configures a virtual host for Apache
	* installs MySQL
	* creates a database called app
	* installs ColdFusion 10 Standalone (and updates it)
	* configures ColdFusion 10 to work behind Apache

For customisations take a look in ../roles/cf10.rb.