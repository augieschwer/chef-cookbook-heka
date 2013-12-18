#
# Cookbook Name:: heka
# Recipe:: default
#

template "/etc/hekad.toml" do
	source "hekad.toml.erb"
	owner "root"
	group "root"
	notifies :restart, "service[heka]", :delayed
end

template "/etc/init/heka.conf" do
	source "heka.conf.erb"
	owner "root"
	group "root"
end

cookbook_file "/usr/bin/hekad" do
	source "hekad"
	action :create_if_missing
	mode '755'
end

service "heka" do
	action [ :enable , :start ]
	provider Chef::Provider::Service::Upstart
end

logrotate_app 'hekad' do
  cookbook  'logrotate'
  path      '/var/log/heka.log'
  missingok true
  frequency 'weekly'
  rotate    4
  create    '644 root root'
end
