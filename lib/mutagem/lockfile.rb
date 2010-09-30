module Mutagem

  # File locking wrapper for Flock
  class Lockfile
    # filename for the lockfile, can include path
    attr_accessor :lockfile

    # Create a new LockFile
    #
    # @param [String] lockfile filename
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
    # lock is removed (but not the lockfile).  Accepts an optional
    # code block.
    #
    # @example
    #
    #     open('output', 'w') do |f|
    #       # exclusive blocking lock
    #       lock(f, File::LOCK_EX) do |f|
    #       f << "write to file while blocking other processes"
    #       end
    #     end
    #
    # @param [Object] file the file IO object returned from a call to "open(filename, mode_string)"
    # @param [Constant] mode locking_constant, see File
    # @return [Boolean] 0 or false if unable to sucessfully lock
    def lock(file, mode)
      result = file.flock(mode)
      if result
        begin
          yield file if block_given?  # may not have block if called by locked?
        ensure
          # unlock but leave the file on the filesystem
          file.flock(File::LOCK_UN)
        end
      end
      return result
    end
  end

end
