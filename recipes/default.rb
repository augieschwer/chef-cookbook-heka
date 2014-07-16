#
# Cookbook Name:: heka
# Recipe:: default
#

if platform?("debian", "ubuntu")

	# install the heka package
	Chef::Log.info("Installing Heka from #{node["heka"]["download"]["remote_src"]}")

	directory node["heka"]["dir"]

	remote_file node["heka"]["download"]["remote_file"] do
		source node["heka"]["download"]["remote_src"]
		:create_if_missing
		not_if { ::File.exists?(node["heka"]["bin"]) }
	end

	dpkg_package "heka" do
		source node["heka"]["download"]["remote_file"]
		notifies :create, "template[#{node["heka"]["init"]}]"
		not_if { ::File.exists?(node["heka"]["bin"]) }
	end

	template node["heka"]["init"] do
		source "heka.conf.erb"
		owner "root"
		group "root"
		# pass values into the template rendering to allow for future template
		# rendering tests
		variables({
			:hostname => node["hostname"],
			:bin => node["heka"]["bin"],
			:log => node["heka"]["log"],
			:conf_dir => node["heka"]["conf_dir"]
		})
		# If the conf changes notify the service to restart
		notifies :restart, "service[heka]"
	end

	service "heka" do
		action [ :enable , :start ]
		provider Chef::Provider::Service::Upstart
	end

	logrotate_app "hekad" do
		cookbook  "logrotate"
		path      node["heka"]["log"]
		missingok true
		frequency "weekly"
		rotate    4
		create    "644 root root"
	end

end
