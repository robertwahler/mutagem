# require all files here
require 'mutagem/lockfile'
require 'mutagem/mutex'
require 'mutagem/task'

# Master namespace
module Mutagem
  
  # Contents of the VERSION file
  #
  # Example format: 0.0.1
  #
  # @return [String] the contents of the version file in #.#.# format
  def self.version
    version_info_file = File.join(File.dirname(__FILE__), *%w[.. VERSION])
    File.open(version_info_file, "r") do |f|
      f.read
    end
  end

end

