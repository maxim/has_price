require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "has_price"
    gem.summary = %Q{Provides a convenient DSL for organizing a price breakdown in a class.}
    gem.description = %Q{A convenient DSL for defining complex price reader/serializer in a class and organizing a price breakdown. Price can be declared with items and groups which depend on other attributes. Price is a very simple subclass of Hash. This provides for easy serialization and flexibility in case of implementation changes. This way you can conveniently store the whole price breakdown in your serialized receipts. It also provides magic methods for convenient access, but can be fully treated as a regular Hash with some sprinkles on top.}
    gem.email = "max@bitsonnet.com"
    gem.homepage = "http://github.com/maxim/has_price"
    gem.authors = ["Maxim Chernyak"]
    gem.add_development_dependency "shoulda", ">= 0"
    gem.add_development_dependency "rr"
    gem.files.include %w(lib/*/**)
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "has_price #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
