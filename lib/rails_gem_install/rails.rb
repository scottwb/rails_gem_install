RAILS_ENV  = ENV['RAILS_ENV']
RAILS_ROOT = Dir.pwd

# A dummy implementation of the Rails module to implement a few things
# we need from Rails in order to compute and install dependencies, plus
# a simplified implementation of the <tt>config.gem</tt> installation
# mechanism. This is all so we can do the parts of <tt>rake gems:install</tt>
# from Rails that we need, without depending on Rails to do it.
module Rails
  def self.root
    RAILS_ROOT
  end

  def self.ensure_installation_version
    puts "[Ensuring correct version of Rails is installed]"
    result = `rake -T 2>&1`
    if result =~ /Missing the Rails (\d+\.\d+\.\d+) gem/
      cmd = "gem install rails --version '#{$1}'"
      puts cmd
      system cmd
      Gem::refresh
    end
  end

  def self.install_gems
    Rails::GemInstaller.install
  end

  class GemInstaller
    def gem(name, options = {})
      g = Rails::GemDependency.new(name, options)
      g.add_load_paths
      g.install if !g.installed?
    end

    def self.install
      # Load Rails's config.gem stuff so we can use it without the rest of
      # Rails...but don't do it until now, because we need other code
      # to run first to make sure the right version is Rails is installed
      # first.
      require 'rails/gem_dependency'

      puts "[Ensuring config.gem gems are all installed]"
      config = self.new
      cmds = File.readlines("config/environment.rb")
      if RAILS_ENV && File.exist?("config/environments/#{RAILS_ENV}.rb")
        cmds += File.readlines("config/environments/#{RAILS_ENV}.rb")
      end
      cmds = cmds.grep(/^\s*config\.gem/).join("\n")
      eval(cmds)
    end
  end
end
