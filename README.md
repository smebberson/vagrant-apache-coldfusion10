vagrant-apache-coldfusion10
===========================

A repository to quickly and easily get started with Apache 2.2 and ColdFusion 10 using Vagrant.

What you get
------------

- Ubuntu 12.04LTS
- Java (Oracle flavour) 1.7
- Apache 2.2
- MySQL
- ColdFusion 10 (developer mode)

*plus...*

- An Apache VirtualHost configured with cfml support
- An empty MySQL database named `app`
- A CF DSN named `app`

Getting started
---------------

Before anything else, you need to go and [grab the ColdFusion 10 installer file](https://www.copy.com/s/nhIbHZYZnmPN/ColdFusion%20Repo/10.0.0/ColdFusion_10_WWEJ_linux64.bin):

Once you have that you can get started:

- Fork and clone this repository
- Initalise the submodules with `git submodule init` and `git submodule update`
- Copy the ColdFusion 1- installer file into `./chef/cookbooks/coldfusion10/files/default/`
- (with Vagrant installed of course) execute `vagrant up`
- Wait for the install to finish
- Visit http://192.168.32.10/ in your browser and you should see a ColdFusion dump of the `server` scope

Customisation
-------------

If you'd like to start customising your installation, here are a few easy steps you can take:

- open `chef/roles/cf10.rb`
- customise values in the `override_attributes` section
- MySQL has been setup with remote access for root, so you can use your favourite GUI to gain access to the database

