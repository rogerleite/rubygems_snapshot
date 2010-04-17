Feature: Show help messages
  In order to see usefull help messages
  A user
  Wants a command line interface
  So that he or she can obtain some help.

  Scenario: using help command from rubygems
    When I run "gem help commands"
    Then I should see "snapshot"
    And I should see "Export/Import your gems."

  Scenario: using help command on snapshot from rubygems
    When I run "gem help snapshot"
    Then I should see "Usage: gem snapshot ACTION(export|import) FILENAME [options]"
