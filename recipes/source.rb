#
# Cookbook Name:: heka
# Recipe:: source
#

HEKA_SRC = ::File.join(node["heka"]["source"]["dir"]["main"],
                       node["heka"]["download"]["version"])

## Install packages required for a source build
node["heka"]["source"]["packages"].each do |pkg|
  package pkg
end

## Create all necessary directories
node["heka"]["source"]["dir"].each do |_, path|
  directory path do
    recursive true
  end
end

## Clone heka from git at specified tag
git HEKA_SRC do
  repository node["heka"]["source"]["git"]["source"]
  revision "v#{node["heka"]["download"]["version"]}"
  action :sync
end

## Add an optional plugin file to cmake
template ::File.join(HEKA_SRC, "cmake/plugin_loader.cmake") do
  source "source/plugin_loader.cmake.erb"
  mode "0644"
  variables(
    :lines => node["heka"]["source"]["plugins"]
  )
end

## Assemble commands to install required packages for heka plugins
go_packages = node["heka"]["source"]["golang"]["packages"].map do |pkg|
  "go get #{pkg}"
end.join("\n")

## Variables needed for the build script
GOBUILD = ::File.join(HEKA_SRC, "build")
GOPATH = ::File.join(HEKA_SRC, "build/heka")
PATH = node["heka"]["source"]["golang"]["PATH"].join(":")

## Build HEKA from source
bash "build_heka" do
  cwd HEKA_SRC
  code <<-EOH
# Extracted and modified from the heka source build.sh and env.sh scripts
export GOPATH=#{GOPATH}
export PATH=$PATH:#{PATH}

#{go_packages}

export BUILD_DIR=#{GOBUILD}
export CTEST_OUTPUT_ON_FAILURE=1

NUM_JOBS=${NUM_JOBS:-1}
# build heka
mkdir -p $BUILD_DIR
cd $BUILD_DIR
cmake -DCMAKE_BUILD_TYPE=release ..
make -j $NUM_JOBS
EOH
  action :run
  not_if { ::File.exist?(::File.join(GOPATH, "bin/hekad")) }
end

## Create the conf directory
directory node["heka"]["dir"]

## Create the upstart script that points to the built hekad binary
## If modified, restart heka
template node["heka"]["init"] do
  source "heka.conf.erb"
  cookbook "heka"
  owner "root"
  group "root"
  variables(
    :hostname => node["hostname"],
    :bin => ::File.join(GOPATH, "bin/hekad"),
    :log => node["heka"]["log"],
    :conf_dir => node["heka"]["conf_dir"]
  )
  notifies :restart, "service[heka]"
end

## Identical logrotation to the binary install
## Changes to the logrotate will notify a restart on service[heka]
logrotate_app "hekad" do
  cookbook  "logrotate"
  path      node["heka"]["log"]
  missingok true
  frequency "weekly"
  rotate    4
  create    "644 root root"
end

## Enable and off you go ....
service "heka" do
  action [:enable, :start]
  provider Chef::Provider::Service::Upstart
end
