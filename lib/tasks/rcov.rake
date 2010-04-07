# From http://github.com/jaymcgavren
#
# Save this as rcov.rake in lib/tasks and use rcov:all =>
# to get accurate spec/feature coverage data

require 'cucumber/rake/task'
require 'rcov/rcovtask'

namespace :rcov do
  
  rcov_opts = ["--exclude", "\"spec/*,gems/*,features/*\"", "--rails", "--aggregate", "\"coverage.data\""]
  

  desc 'Measures cucumber coverage'
  Cucumber::Rake::Task.new(:features) do |t|
    t.rcov = true
    t.rcov_opts = rcov_opts
    t.rcov_opts << '-o coverage'
  end

  desc 'Measures shoulda coverage'
  Rcov::RcovTask.new(:tests) do |t|
    t.libs << 'test'
    #Rake::Task["db:test:prepare"].invoke
    t.test_files = FileList['test/unit/*_test.rb'] + FileList['test/functional/*_test.rb']
    t.rcov_opts = rcov_opts
    t.output_dir = "coverage"
  end

  desc 'Measures all coverage'
  task :all do
    rm "coverage.data" if File.exist?("coverage.data")
    ["tests", "features"].each{ |task| Rake::Task["rcov:#{task}"].invoke }
  end
end