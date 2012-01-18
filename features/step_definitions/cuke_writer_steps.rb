Given /^a serial number "([^"]*)"$/ do |serial_number|
  SerialNumber.number = serial_number
end

Given /^a typical support\/env.rb file$/ do
  step "a file named \"features/support/env.rb\" with:", <<-EOF
require File.dirname(__FILE__) + '/../../../../lib/cuke_writer'
require File.dirname(__FILE__) + '/../../../../lib/step_collector'
require File.dirname(__FILE__) + '/../../../../lib/serial_number'

SerialNumber.number = "P123456"
  EOF
end

When /^I run the "([^"]*)" feature$/ do |feature_name|
    step "I run \`cucumber features/#{feature_name}.feature -f CukeWriter::Formatter -o cuke_writer.txt -f progress\`"
end
