#
# Cookbook Name:: app
# Recipe:: db
#

include_recipe "database::mysql"
include_recipe "coldfusion10"

# define the connection info
mysql_connection_info = {
	:host => "localhost",
	:username => "root",
	:password => node['mysql']['server_root_password']
}

# create the database
mysql_database "app" do
	connection mysql_connection_info
	action :create
end

# create the datasource
coldfusion10_config "datasource" do
	action :set
	property "MySQL5"
	args(node['cf10']['config_settings']['datasource']['MySQL'])
end