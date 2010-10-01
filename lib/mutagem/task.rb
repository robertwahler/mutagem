require 'thread'

module Mutagem
  
  #  A simple external process management wrapper
  #
  # @example
  #
  #     cmd = "diff file1.txt file2.txt"
  #     task = Mutagem::Task.new(cmd)
  #     task.join
  #
  #     if (task.exitstatus == 0)
  #       puts "files match"
  #     end
  class Task
    # @return [String] command to run
    attr_reader :cmd
    attr_accessor :thread

    # create a new Task
    #
    # @param [String] cmd the cmd to execute
    def initialize(cmd)
      @cmd = cmd
      @thread = Thread.new do
        pipe = IO.popen(cmd + " 2>&1")
        @pid = pipe.pid
        begin
          @output = pipe.readlines
          pipe.close
          @exitstatus = $?.exitstatus
        rescue => e
          @exception = e
        end
      end 
    end
     
    # @return [Array] array of strings from the subprocess output
    def output
      @output
    end

    # @return subprocess exit status
    def exitstatus
      @exitstatus
    end

    # @return subprocess pid 
    def pid
      @pid
    end

    # @return [Exception] exception returned if one is thrown by Task
    def exception
      @exception
    end
    
    # join the task's thead and wait for it to finish
    def join
      thread.join
    end

  end

end
