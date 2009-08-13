require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "flood"
    gem.summary = %Q{Ruby library to implement flood control}
    gem.description = %Q{Flood is a Ruby library for flood control. Flood control is limiting events processed to a maximum number in a specified time period.}
    gem.email = "neil@kohlweb.com"
    gem.homepage = "http://github.com/nedski/flood"
    gem.authors = ["Neil Kohl"]

  end

rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new("test_units") {|t|
  t.pattern = 'test/ts_*.rb'
  t.verbose = true
  t.warning = true
}
# Rake::TestTask.new("test_units") do |test|
#   test.libs << 'lib' << 'test'
#   test.pattern = 'test/ts_*.rb'
#   test.verbose = true
# end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end




task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "flood #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
