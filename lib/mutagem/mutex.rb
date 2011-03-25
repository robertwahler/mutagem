require 'fileutils'

module Mutagem

  # File based mutex
  class Mutex < Lockfile

    # Creates a new Mutex
    #
    # @param [String] lockfile filename
    def initialize(lockfile='mutagem.lck')
      super lockfile
    end

    # Protect a block
    #
    # @example
    #
    #    require 'rubygems'
    #    require 'mutagem'
    #
    #    mutex = Mutagem::Mutex.new("my_process_name.lck")
    #    mutex.execute do
    #      puts "this block is protected from recursion"
    #    end
    #
    # @param block the block of code to protect with the mutex
    # @return [Boolean] 0 if lock sucessful, otherwise false
    def execute(&block)
      result = false
      raise ArgumentError, "missing block" unless block_given?

      begin
        open(lockfile, 'w') do |f|
          # exclusive non-blocking lock
          result = lock(f, File::LOCK_EX | File::LOCK_NB) do |f|
            yield
          end
        end
      ensure
        # clean up but only if we have a positive result meaning we wrote the lockfile
        FileUtils.rm(lockfile) if (result && File.exists?(lockfile))
      end

      result
    end
  end

end
