# From http://github.com/jaymcgavren
#
# Save this as rcov.rake in lib/tasks and use rcov:all =>
# to get accurate spec/feature coverage data

require 'cucumber/rake/task'
require 'rcov/rcovtask'

namespace :rcov do
  
  rcov_opts = ["--exclude", "\"spec/*,gems/*,features/*\"", "--rails", "--aggregate", "\"coverage.data\""]
  


  desc 'Measures tests coverage'
  Rcov::RcovTask.new(:tests) do |t|
    t.libs << 'test'
    #Rake::Task["db:test:prepare"].invoke
    t.test_files = FileList['test/unit/*_test.rb'] + FileList['test/functional/*_test.rb']
    t.rcov_opts = rcov_opts
    t.output_dir = "coverage"
  end
end