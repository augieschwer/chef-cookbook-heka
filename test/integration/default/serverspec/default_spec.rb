# vim: ft=ruby.serverspec

require 'spec_helper'

describe package('heka') do
    it { should be_installed }
end

describe service('heka') do
	it { should be_enabled }
	it { should be_running }
end

