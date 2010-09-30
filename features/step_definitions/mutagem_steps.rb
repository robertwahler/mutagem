
Given /^a Ruby source file that uses mutagem named "([^\"]*)"$/ do |filename|
  steps %Q{
    Given a file named "#{filename}" with:
      """
      $LOAD_PATH.unshift File.expand_path('../../../lib', __FILE__) unless
        $LOAD_PATH.include? File.expand_path('../../../lib', __FILE__)

      require 'mutagem'

      mutext = Mutagem::Mutex.new
      mutext.execute do
        puts "hello world"
        exit 0
      end
      exit 1
      """
  }
end

When /^I run with a lock file present "(.*)"$/ do |cmd|
  lockfile = File.join(current_dir, 'mutagem.lck')
  Mutagem::Mutex.new(lockfile).execute do
    run(unescape(cmd), false)
  end
end
