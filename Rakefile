require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "rails_gem_install"
    gem.summary = %Q{Installs gem dependencies for a Rails 2 project.}
    gem.description = %Q{Installs gem dependencies for a Rails 2 project where `rake gems:install` fails. I.e.: breaks the circular dependencies of requiring Rails and anything your vendored gems/plugins require in order to install these requirements.}
    gem.email = "scottwb@gmail.com"
    gem.homepage = "http://github.com/scottwb/rails_gem_install"
    gem.authors = ["Scott W. Bradley"]
    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.add_development_dependency "rcov", ">= 0.9.8"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "rails_gem_install #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('CHANGES*')
  rdoc.rdoc_files.include('LICENSE*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
