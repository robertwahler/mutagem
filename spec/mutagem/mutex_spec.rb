require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Mutagem::Mutex do
  
  before(:each) do
    # remove tmp/aruba
    FileUtils.rm_rf(current_dir)
  end
  
  it "should create a mutex, yield, and clean up" do
    in_current_dir do
      mutex = Mutagem::Mutex.new
      result = mutex.execute do
        File.should be_file('mutagem.lck')
        mutex.should be_locked
      end
      result.should be_true
      mutex.should_not be_locked
      File.should_not be_file('mutagem.lck')
    end
  end

  it "should prevent recursion but not block" do
    in_current_dir do
      Mutagem::Mutex.new.execute do
        File.should be_file('mutagem.lck')

        mutex = Mutagem::Mutex.new
        result = mutex.execute do
          # This block is protected, should not be here
          true.should be(false)
        end
        result.should be_false
        mutex.should be_locked
      end
      File.should_not be_file('mutagem.lck')
    end
  end

  it "should raise ArgumentError unless a block is given" do
    in_current_dir do
      mutex = Mutagem::Mutex.new
      lambda {result = mutex.execute}.should raise_error(ArgumentError, 'missing block')
    end
  end

end


