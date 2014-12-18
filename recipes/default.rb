#
# Cookbook Name:: heka
# Recipe:: default
#

if platform?("debian", "ubuntu")

	# Get current version of installed heka package if any.
	dpkg_query = Mixlib::ShellOut.new("dpkg-query -W -f '${Version}' heka 2>/dev/null")
	dpkg_query.run_command
	heka_version = dpkg_query.stdout

	Chef::Log.debug("Currently installed version of heka: #{heka_version}")
	Chef::Log.debug("Desired version of heka: #{node['heka']['download']['version']}")
	
	# Compare currently installed to desired installed based on attributes.
	if heka_version < node['heka']['download']['version']

		Chef::Log.info("Installing latest Heka from #{node["heka"]["download"]["remote_src"]}")

		remote_file node["heka"]["download"]["remote_file"] do
			source node["heka"]["download"]["remote_src"]
			:create_if_missing
		end

		dpkg_package "heka" do
			source node["heka"]["download"]["remote_file"]
			notifies :create, "template[#{node["heka"]["init"]}]"
		end

	else

		Chef::Log.info("Latest Heka already installed")

	end

	directory node["heka"]["dir"]

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
