
# Name of the role should match the name of the file
name "cf10"

# Overrides
override_attributes(
	"apache" => {
		"version" => "2.2"
	},
	"mysql" => {
		"server_root_password" => "root",
		"data_dir" => "/data",
		"allow_remote_root" => true
	},
	"java" => {
		"install_flavor" => "oracle",
		"java_home" => "/usr/lib/jvm/java-7-oracle",
		"jdk_version" => "7",
		"oracle" => {
			"accept_oracle_download_terms" => true
		}
	},
	"cf10" => {
		"installer" => {
			"cookbook_file" => "ColdFusion_10_WWEJ_linux64.bin"
		},
		"webroot" => "/vagrant/app",
		"config_settings" => {
			"datasource" => {
				"MySQL" => {
					"name" => "app",
					"host" => "localhost",
					"database" => "app",
					"username" => "root",
					"password" => "root"
				}
			}
		}
	},
	"app" => {
		"server_name" => "192.168.99.10",
		"doc_root" => "/vagrant/app"
	}
)

# The recipes run list
run_list(
	"recipe[apt]",
	"recipe[build-essential]",
	"recipe[apache2]",
	"recipe[mysql::server]",
	"recipe[java]",
	"recipe[database::mysql]",
	"recipe[coldfusion10]",
	"recipe[app::vhost]",
	"recipe[app::db]",
)