require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Mutagem do
  
  describe 'version' do

    it "should return a string formatted '#.#.#'" do
      Mutagem::version.should match(/(^[\d]+\.[\d]+\.[\d]+$)/)
    end

  end

end
