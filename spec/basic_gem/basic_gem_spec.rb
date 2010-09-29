require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Mutagem do
  
  describe 'VERSION' do

    it "should return a string formatted '#.#.#'" do
      Mutagem::VERSION.should match(/(^[\d]+\.[\d]+\.[\d]+$)/)
    end

  end

end
