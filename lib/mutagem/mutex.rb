module Mutagem

  # Typical usage:
  #
  #    require 'mutagem'
  #
  #    mutext = Mutagem::Mutex.new
  #    mutext.execute do
  #      puts "this block is protected from recursion"
  #    end
  #
  class Mutex < Lockfile

    def initialize(lockfile='mutagem.lck')
      super lockfile
    end

    def execute
      result = false
      begin
        open(@lockfile, 'w') do |f|
          # exclusive non-blocking lock
          result = lock(f, File::LOCK_EX | File::LOCK_NB) do |f|
            yield if block_given?
          end
        end
      ensure
        # clean up but only if we have a positive result meaning we wrote the lockfile
        FileUtils.rm(@lockfile) if (result && File.exists?(@lockfile))
      end
      result
    end
  end

end
