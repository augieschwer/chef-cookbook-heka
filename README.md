[![Build Status](https://travis-ci.org/augieschwer/chef-cookbook-heka.svg?branch=master)](https://travis-ci.org/augieschwer/chef-cookbook-heka)

Description
===========

Installs Heka from package.

Requirements
============

### Cookbooks

Logrotate

### Platforms

* Chef 0.11.x
* Ubuntu 12.04
* Ubuntu 14.04

Attributes
==========

### Default

```ruby
node['heka']['download']['mirror'] = 'https://github.com/mozilla-services/heka/releases/download/v'
node['heka']['download']['version'] = '0.7.1'
node['heka']['download']['arch'] = 'amd64'
node['heka']['download']['extension'] = 'deb'
```

Usage
=====

Add "heka" to a node's "run_list".

Read http://hekad.readthedocs.org/en/latest/ .

Add your TOML configuration files into the /etc/heka/ directory.

Custom Version
==============

To override the default heka version, override the following attributes

```ruby
override["heka"]["download"]["version"] = "0.7.0"
override["heka"]["download"]["remote_src"] = \
  "#{node["heka"]["download"]["mirror"]}#{node["heka"]["download"]["version"]
  }/heka_#{node["heka"]["download"]["version"]
  }_#{node["heka"]["download"]["arch"]
  }.#{node["heka"]["download"]["extension"]}"
override["heka"]["download"]["remote_file"] = ::File.join(
  "/tmp",
  "heka_#{node["heka"]["download"]["version"]}_#{
  node["heka"]["download"]["arch"]}.#{node["heka"]["download"]["extension"]}")
```

