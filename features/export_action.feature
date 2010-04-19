Feature: Export installed gems
  In order to export gems
  A user
  Wants a command line interface
  So that he or she can export gems.

  Scenario: using export with default format
    When I run "gem snapshot export tmp/test.tar"
    Then I should see "Gems exported to tmp/test.tar successfully."
    And I run "tar -tf tmp/test.tar"
    And I should see "gems/rake-0.8.7.gem"
    And I should see "gems/rubygems_snapshot-0.2.0.gem"
    And I should see "gems.yml"

  Scenario: using export with tar format and no cache gem
    Given I run "rm tmp/fake_gems/cache/rake*"
    When I run "gem snapshot export tmp/test.tar"
    Then I should see "Gems exported to tmp/test.tar successfully."
    And I run "tar -tf tmp/test.tar"
    And I should not see "gems/rake-0.8.7.gem"
    And I should see "gems/rubygems_snapshot-0.2.0.gem"
    And I should see "gems.yml"

  Scenario: using export with yml format argument
    When I run "gem snapshot export tmp/test.yml -f yml"
    Then I should see "Gems exported to tmp/test.yml successfully."
    And I should see file "tmp/test.yml" content like
      """
      --- 
      sources: 
      - http://gemcutter.org
      gems: 
      - name: rake
        versions: 
        - 0.8.7
      - name: rubygems_snapshot
        versions: 
        - 0.2.0

      """

