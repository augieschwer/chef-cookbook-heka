Description
===========

Installs Heka from package.

Requirements
============

### Cookbooks

Logrotate

### Platforms

Chef 0.11.x
Ubuntu 12.04

Attributes
==========

### Default

`node['heka']['download']['mirror'] = 'https://github.com/mozilla-services/heka/releases/download/v'`

`node['heka']['download']['version'] = '0.5.1'`

`node['heka']['download']['arch'] = 'amd64'`

`node['heka']['download']['extension'] = 'deb'`


Usage
=====

Add "heka" to a node's "run_list".

Read http://hekad.readthedocs.org/en/latest/ .

Add your TOML configuration files into the /etc/heka/ directory.

