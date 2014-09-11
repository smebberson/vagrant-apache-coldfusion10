#
# Cookbook Name:: app
# Recipe:: coldfusion-apache
#
# Inspiration and majority of the code for this has come from https://github.com/wharton/chef-coldfusion10

# Disable the default site
apache_site "default" do
	enable false
end

# Create the mechanic virtual host
web_app "app" do
	server_name node['app']['server_name']
	server_aliases [node["fqdn"]]
	allow_override "all"
	docroot node['app']['doc_root']
	template "app.conf.erb"
end

# Make sure CF is running
execute "start_cf_for_coldfusion10_wsconfig" do
	command "/bin/true"
	notifies :start, "service[coldfusion]", :delayed
	notifies :run, "execute[uninstall_wsconfig]", :delayed
	notifies :run, "execute[install_wsconfig]", :delayed
	only_if "#{node['cf10']['installer']['install_folder']}/cfusion/runtime/bin/wsconfig -list 2>&1 | grep 'There are no configured web servers'"
end

# wsconfig 
execute "install_wsconfig" do
	case node['platform_family']
		when "rhel", "fedora", "arch"
			command <<-COMMAND
			sleep 11
			#{node['cf10']['installer']['install_folder']}/cfusion/runtime/bin/wsconfig -ws Apache -dir #{node['apache']['dir']}/conf -bin #{node['apache']['binary']} -script /usr/sbin/apachectl -v
			cp -f #{node['apache']['dir']}/conf/httpd.conf.1 #{node['apache']['dir']}/conf/httpd.conf
			cp -f #{node['apache']['dir']}/conf/mod_jk.conf #{node['apache']['dir']}/conf.d/mod_jk.conf
			sleep 11
			COMMAND
		else
			command <<-COMMAND
			sleep 11
			#{node['cf10']['installer']['install_folder']}/cfusion/runtime/bin/wsconfig -ws Apache -dir #{node['apache']['dir']} -bin #{node['apache']['binary']} -script /usr/sbin/apache2ctl -v
			cp -f #{node['apache']['dir']}/httpd.conf.1 #{node['apache']['dir']}/httpd.conf 
			mv #{node['apache']['dir']}/mod_jk.conf #{node['apache']['dir']}/conf-available/mod_jk.conf
			a2enconf mod_jk
			sleep 11
			COMMAND
		end
	action :nothing  
	notifies :restart, "service[apache2]", :immediately
	only_if "#{node['cf10']['installer']['install_folder']}/cfusion/runtime/bin/wsconfig -list 2>&1 | grep 'There are no configured web servers'"
end

execute "uninstall_wsconfig" do
	case node['platform_family']
		when "rhel", "fedora", "arch"
			command <<-COMMAND
			sleep 11
			#{node['cf10']['installer']['install_folder']}/cfusion/runtime/bin/wsconfig -uninstall -bin #{node['apache']['binary']} -script /usr/sbin/apachectl -v
			rm -f #{node['apache']['dir']}/conf/httpd.conf.1 
			rm -f #{node['apache']['dir']}/conf.d/mod_jk.conf
			sleep 11
			COMMAND
		else
			command <<-COMMAND
			sleep 11
			#{node['cf10']['installer']['install_folder']}/cfusion/runtime/bin/wsconfig -uninstall -bin #{node['apache']['binary']} -script /usr/sbin/apache2ctl -v
			rm -f #{node['apache']['dir']}/httpd.conf.1
			a2disconf mod_jk
			rm -f #{node['apache']['dir']}/conf-available/mod_jk.conf
			sleep 11
			COMMAND
		end
	action :nothing  
	notifies :restart, "service[apache2]", :immediately
	only_if "#{node['cf10']['installer']['install_folder']}/cfusion/runtime/bin/wsconfig -list | grep 'Apache : #{node['apache']['dir']}'"
end

