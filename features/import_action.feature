Feature: Import gems
  In order to import gems
  A user
  Wants a command line interface
  So that he or she can import gems.

# TODO: Find a way to install gem "from internet" without accessing internet.
#  Scenario: using yml import (internet needed)
#    Given I have a file "tmp/import_test.yml" with content
#      """
#      --- 
#      sources: 
#      - http://rubygems.org/
#      gems: 
#      - name: json
#        versions: 
#        - 1.4.2
#      """
#    When I run "gem snapshot import tmp/import_test.yml -f yml"
#    Then I should not see "json-1.4.2.gem"
#    And I should see "Gems imported successfully."
#    And I run "gem list"
#    Then I should see "json (1.4.2)"

  Scenario: yml import should check if gem is not available
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
    And I run "gem install tmp/gems/json-1.4.2.gem --no-ri --no-rdoc"
    And I run "gem install tmp/gems/json-1.4.1.gem --no-ri --no-rdoc"
    When I run "gem snapshot import tmp/import_test.yml -f yml"
    Then I should see "json-1.4.2 already available!"

  Scenario: using yml import, checking cache for install
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
    And I run "gem uninstall json -a -x -I"
    And I run "cp tmp/gems/json-1.4.2.gem tmp/fake_gems/cache"
    When I run "gem snapshot import tmp/import_test.yml -f yml"
    Then I should see "json-1.4.2.gem"
    And I should see "Gems imported successfully."
    And I run "gem list"
    Then I should see "json (1.4.2)"
