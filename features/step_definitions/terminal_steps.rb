
When /^I run "([^\"]*)"$/ do |syscommand|
  command = gsub_command(syscommand)
  execute(command)
end

Then /^I should see "([^\"]*)"$/ do |data|
  output.should match(Regexp.new(Regexp.escape(data)))
end

Then /^I should not see "([^\"]*)"$/ do |data|
  output.should_not match(Regexp.new(Regexp.escape(data)))
end

Then /^I should see file "([^\"]*)" content like$/ do |filename, content|
  File.read(filename).should == content
end

Given /^I have a file "([^\"]*)" with content$/ do |filename, content|
  File.open(filename, "w+") { |file| file.puts content }
end

