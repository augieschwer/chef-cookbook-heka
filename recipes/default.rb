#
# Cookbook Name:: heka
# Recipe:: default
#

if platform?("debian", "ubuntu")

	# install the heka package
	Chef::Log.info("Installing Heka from #{node['heka']['download']['mirror']}#{node['heka']['download']['version']}/heka_#{node['heka']['download']['version']}_#{node['heka']['download']['arch']}.#{node['heka']['download']['extension']}")
	remote_file "/tmp/heka_#{node['heka']['download']['version']}_#{node['heka']['download']['arch']}.#{node['heka']['download']['extension']}" do
		source "#{node['heka']['download']['mirror']}#{node['heka']['download']['version']}/heka_#{node['heka']['download']['version']}_#{node['heka']['download']['arch']}.#{node['heka']['download']['extension']}"
		not_if "dpkg-query -l 'heka'"
	end

	dpkg_package "heka" do
		source "/tmp/heka_#{node['heka']['download']['version']}_#{node['heka']['download']['arch']}.#{node['heka']['download']['extension']}"
		action :install
		not_if "dpkg-query -l 'heka'"
	end

	directory "/etc/heka" do
		action :create
	end

	template "/etc/init/heka.conf" do
		source "heka.conf.erb"
		owner "root"
		group "root"
	end

	service "heka" do
		action [ :enable , :start ]
		provider Chef::Provider::Service::Upstart
	end

	logrotate_app 'hekad' do
		cookbook  'logrotate'
		path      '/var/log/hekad.log'
		missingok true
		frequency 'weekly'
		rotate    4
		create    '644 root root'
	end

end
