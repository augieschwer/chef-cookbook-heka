#!/usr/bin/env rake

desc "Run foodcritic"
task :foodcritic do
	sh "foodcritic --epic-fail any . "
end

desc "Run Serverspec"
task :serverspec do
	sh "/usr/bin/ruby -S rspec test/integration/default/serverspec/default_spec.rb"
end

task :default => 'foodcritic'
