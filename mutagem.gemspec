# -*- encoding: utf-8 -*-
#
#

Gem::Specification.new do |s|

  # wrap 'git' so we can get gem files even on systems without 'git'
  #
  # @see spec/gemspec_spec.rb
  #
  @gemfiles ||= begin
    filename  = File.join(File.dirname(__FILE__), '.gemfiles')
    # backticks blows up on Windows w/o valid binary, use system instead
    if File.directory?('.git') && system('git ls-files bogus-filename')
      files = `git ls-files`
      cached_files = File.exists?(filename) ? File.open(filename, "r") {|f| f.read} : nil
      # maintain EOL
      files.gsub!(/\n/, "\r\n") if cached_files && cached_files.match("\r\n")
      File.open(filename, 'wb') {|f| f.write(files)} if cached_files != files
    else
      files = File.open(filename, "r") {|f| f.read}
    end
    raise "unable to process gemfiles" unless files
    files.gsub(/\r\n/, "\n")
  end

  s.name        = "mutagem"
  s.version     = File.open(File.join(File.dirname(__FILE__), 'VERSION'), "r") { |f| f.read }
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Robert Wahler"]
  s.email       = ["robert@gearheadforhire.com"]
  s.homepage    = "http://rubygems.org/gems/mutagem"
  s.summary     = "File based mutexes with a simple external process management wrapper"
  s.description = "The Mutagem library provides file based mutexes for recursion protection and
                   classes for threading of external processes with support for output and
                   exit status capturing. A test suite is provided for both unit and functional testing.
                   The code is documented using YARD."

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "mutagem"

  s.add_development_dependency "bundler", ">= 1.0.14"
  s.add_development_dependency "rspec", "~> 1.3.1"
  s.add_development_dependency "aruba", "= 0.2.2"
  s.add_development_dependency "rake", "~> 0.9.2"
  s.add_development_dependency "cucumber", "~> 1.3.2"

  s.files        = @gemfiles.split("\n")
  s.executables  = @gemfiles.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact

  s.require_path = 'lib'

  s.rdoc_options     = [
                         '--title', 'Mutagem Documentation',
                         '--main', 'README.markdown',
                         '--line-numbers',
                         '--inline-source'
                       ]
end
