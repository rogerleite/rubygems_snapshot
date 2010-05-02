Feature: Import gems
  In order to import gems
  A user
  Wants a command line interface
  So that he or she can import gems.

  @wip
  Scenario: using yml import
    Given I have a file "tmp/import_test.yml" with content
      """
      --- 
      sources: 
      - http://rubygems.org/
      gems: 
      - name: json
        versions: 
        - 1.4.2
      """
    When I run "gem snapshot import tmp/import_test.yml -f yml"
    Then I should see "Gems imported successfully."
    And I run "gem list"
    Then I should see "json (1.4.2)"
