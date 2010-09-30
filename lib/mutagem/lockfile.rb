module Mutagem

  class Lockfile
    attr_accessor :lockfile

    def initialize(lockfile=nil)
      raise ArgumentError, "lockfile not specified" unless lockfile
      @lockfile = lockfile
    end

    # Does another process have a lock?
    # True if we can't get an exclusive lock
    def locked?
      return false unless File.exists?(lockfile)
      result = false
      open(lockfile, 'w') do |f|
        # exclusive non-blocking lock
        result = !lock(f, File::LOCK_EX | File::LOCK_NB)
      end
      result
    end

    # Get a file lock with flock and ensure the 
    # lock is removed (but not the lockfile) after 
    # yielding to a code block
    #
    # Typical usage:
    #
    #     open('output', 'w') do |f|
    #       # exclusive blocking lock
    #       lock(f, File::LOCK_EX) do |f|
    #       f << "write to file"
    #       end
    #     end
    #
    def lock(file, mode)
      result = file.flock(mode)
      if result
        begin
          yield file if block_given?
        ensure
          # unlock but leave the file on the filesystem
          file.flock(File::LOCK_UN)
        end
      end
      return result
    end
  end

end
