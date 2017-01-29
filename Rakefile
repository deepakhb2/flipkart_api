require 'rake'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new do |task|
  test_dir = "spec"
  task.pattern = "#{test_dir}/*_spec.rb"
end 

task :default  => :spec
