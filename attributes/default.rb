#
# Cookbook Name:: heka
# Attribute:: default
#

# https://github.com/mozilla-services/heka/releases/download/v0.5.1/heka_0.5.1_amd64.deb
# Package download defaults
default['heka']['download']['mirror'] = 'https://github.com/mozilla-services/heka/releases/download/v'
default['heka']['download']['version'] = '0.6.0'
default['heka']['download']['arch'] = 'amd64'
default['heka']['download']['extension'] = 'deb'
default['heka']['download']['remote_src'] = "#{node['heka']['download']['mirror']}#{node['heka']['download']['version']}/heka_#{node['heka']['download']['version']}_#{node['heka']['download']['arch']}.#{node['heka']['download']['extension']}"
default['heka']['download']['remote_file'] = ::File.join("/tmp", "heka_#{node['heka']['download']['version']}_#{node['heka']['download']['arch']}.#{node['heka']['download']['extension']}")
default['heka']['bin'] = '/usr/bin/hekad'
default['heka']['init'] = '/etc/init/heka.conf'
default['heka']['dir'] = '/etc/heka'
default['heka']['conf_dir'] = '/etc/heka/'
default['heka']['log'] = '/var/log/hekad.log'
