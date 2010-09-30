@announce
Feature: File based mutexes

  Automated processes need locking to prevent recursion on long running commands

  Scenario: Process runs with no lock file present
    Given a Ruby source file that uses Mutagem::Mutex named "test.rb"
    When I run "ruby test.rb"
    Then the exit status should be 0
    And the output should contain:
      """
      hello world
      """

  Scenario: Process runs with a lock file present
    Given a Ruby source file that uses Mutagem::Mutex named "test.rb"
    When I run with a lock file present "ruby test.rb"
    Then the exit status should be 1
    And the output should not contain:
      """
      hello world
      """
