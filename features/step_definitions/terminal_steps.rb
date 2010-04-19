
When /^I run "([^\"]*)"$/ do |syscommand|
  command = gsub_command(syscommand)
  execute(command)
end

Then /^I should see "([^\"]*)"$/ do |data|
  output.should match(Regexp.new(Regexp.escape(data)))
end

Then /^I should see file "([^\"]*)" content like$/ do |filename, content|
  File.read(filename).should == content
end

