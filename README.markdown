Mutagem
========

A Ruby gem for file based mutexes with a simple external process management wrapper.


Overview
--------
The Mutagem library provides file based mutexes for recursion protection and wrapper classes for
external processes with support for output and exit status capturing.

A test suite is provided for both unit testing with [RSpec](http://github.com/dchelimsky/rspec)
and functional testing with [Cucumber](http://github.com/aslakhellesoy/cucumber).  The code is
documented using [YARD](http://github.com/lsegal/yard).  Mutagem development was jump-started by
cloning [BasicGem](http://github.com/robertwahler/basic_gem).


Example Usage
-------------
The following Ruby code is used to run a word by word diff on two folders of comma delimited data.
Each folder contains before and after CSV dumps from a SQL database.  The CSV files have the same name
in each of the two folders.

Mutagem is providing recursion protection.  The recursion protection is very useful if the script is
run in an automated environment (ex. cron).  Mutagem is also capturing output and exit status for the
diff processes allowing customized output.

Standard diff is quick but it can't give you a word by word diff of CSV data.  Word by word
colorized diffing with support for custom delimiters is provided
by [dwdiff](http://os.ghalkes.nl/dwdiff.html).


    #!/usr/bin/env ruby

    require 'rubygems'
    require 'mutagem'
    require 'pathname'
    require 'term/ansicolor'

    class String
      include Term::ANSIColor
    end

    lock_was_sucessful = Mutagem::Mutex.new('diff.lck').execute do

      $stdout.sync = true # force screen updates
      before_files = Dir.glob('test/dump/before/*.csv')

      before_files.each do |bf|

        af = 'test/dump/after/' + Pathname.new(bf).basename.to_s

        # quick diff
        cmd = "diff #{bf} #{af}"
        task = Mutagem::Task.new(cmd)
        task.run

        if (task.exitstatus == 0)
          # no changes, show a "still working" indicator
          print ".".green
        else
          # we have changes, slow diff, word based and CSV (comma) sensitive
          print "D".red
          puts "\n#{af}"

          cmd = "dwdiff --color --context=0 --delimiters=, #{bf} #{af}"
          task = Mutagem::Task.new(cmd)
          task.run

          puts task.output
        end

      end
      puts "\n"

    end
    puts "process locked" unless lock_was_sucessful


System Requirements
-------------------
* POSIX system (tested on Linux and Windows/Cygwin environments)


Installation
------------
Mutagem is avaliable on [RubyGems.org](http://rubygems.org/gems/mutagem)

    gem install mutagem


Development
-----------

Mutagem uses [Bundler](http://github.com/carlhuda/bundler) to manage dependencies, the gemspec
file is maintained by hand.

    git clone http://github.com/robertwahler/mutagem
    cd mutagem

Use bundle to install development dependencies

    bundle install

rake -T

    rake build         # Build mutagem-0.1.2.gem into the pkg directory
    rake doc:clean     # Remove generated documenation
    rake doc:generate  # Generate YARD Documentation
    rake features      # Run Cucumber features
    rake install       # Build and install mutagem-0.1.2.gem into system gems
    rake release       # Create tag v0.1.2 and build and push mutagem-0.1.2.gem to Rubygems
    rake spec          # Run specs
    rake test          # Run specs and features


Copyright
---------

Copyright (c) 2010 GearheadForHire, LLC. See [LICENSE](LICENSE) for details.
