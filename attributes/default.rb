#
# Cookbook Name:: heka
# Attribute:: default
#

# https://github.com/mozilla-services/heka/releases/download/v0.5.1/heka_0.5.1_amd64.deb
# Package download defaults
default['heka']['download']['mirror'] = 'https://github.com/mozilla-services/heka/releases/download/v'
default['heka']['download']['version'] = '0.5.1'
default['heka']['download']['arch'] = 'amd64'
default['heka']['download']['extension'] = 'deb'

