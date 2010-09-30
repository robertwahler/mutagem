@announce
Feature: Simple process management wrapper

  Manage subprocess tasks in a separate thread
  in order to capture the output and manage additional tasks
  based on the subprocess exit status

  Scenario: Process runs with no lock file present
    Given a Ruby source file that uses Mutagem::Task named "tasker.rb"
    When I run "ruby tasker.rb"
    Then the exit status should be 2
    And the output should contain:
      """
      hello world
      """
