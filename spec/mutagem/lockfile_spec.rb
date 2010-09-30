require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Mutagem::Lockfile do
  
  before(:each) do
    # remove tmp/aruba
    FileUtils.rm_rf(current_dir)
  end
  
  it "should raise ArgumentError if initialized without a lock filename" do
    in_current_dir do
      lambda {Mutagem::Lockfile.new}.should raise_error(ArgumentError, 'lockfile not specified')
      lambda {Mutagem::Lockfile.new('mylock.lock')}.should_not raise_error
    end
  end

end


