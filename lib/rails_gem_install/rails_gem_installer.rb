class RailsGemInstaller
  def initialize
    @installed_gems = []
  end

  # Parses out any gems that were required by the Rails project, but
  # couldn't be found when the rake task caused them to try to be loaded.
  def parse_required(input)
    gemspecs = []
    input.split("\n").grep(/^no such file to load -- (.+)\s*$/) do |line|
      gemspecs << {:name => $1.strip}
    end
    gemspecs
  end

  # Parses out any gems that were specified by config.gem in the Rails
  # project initializers that are missing.
  def parse_missing(input)
    matches = input.match(/Missing these required gems:([\s\S]*)You're running:/)
    return [] if matches.nil?
    matches[1].strip.split("\n").map do |line|
      m = line.match(/^\s*(\S+)\s+(\S+\s+[0-9.]+)/)
      p line if m.nil?
      {:name => m[0], :version => m[1]}
    end
  end
  
  # Parses out any dependency gems listed that are not yet satisified.
  def parse_deps(input)
    matches = input.scan(/\s+-\s+\[ \]\s+(\S+)\s+(\S+\s+[0-9.]+)/) || []
    matches.map do |match|
      {:name => match[0], :version => match[1]}
    end
  end

  # Gets the set of required gems that need to be installed.
  def get_requirements
    result = `rake gems 2>&1`
    parse_required(result) + parse_missing(result) + parse_deps(result)
  end

  # Installs the specified gem.
  def install_gem(gemspec)
    if @installed_gems.include?(gemspec[:name])
      raise "Already installed #{gemspec[:name]} once. Make sure that GEM_HOME and GEM_PATH are set correctly."
    end
    @installed_gems << gemspec[:name]
    cmd = "gem install #{gemspec[:name]}"
    if gemspec[:version]
      cmd << " --version '#{gemspec[:version]}'"
    end

    # On Mac OS X, if we're not root we need to explicitly tell gem
    # to do a user install.
    if (RUBY_PLATFORM =~ /darwin/i) && (Process.euid != 0)
      cmd << " --user-install"
    end

    puts cmd
    system cmd
  end

  # Finds all the gems that need to be installed for this Rails project to
  # run, and installs them.
  def install_gems
    puts "[Checking for missing required gems]"
    while (gemspecs = get_requirements).any?
      gemspecs.each do |gemspec|
        install_gem(gemspec)
      end
    end
  end

  # Instantiates a new RailsGemInstaller and calls its install_gems method.
  # This is provided for convenience.
  def self.install_gems
    self.new.install_gems
  end
end
