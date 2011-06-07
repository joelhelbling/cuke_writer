Given /^a serial number "([^"]*)"$/ do |serial_number|
  SerialNumber.number = serial_number
end

Given /^a typical support\/env.rb file$/ do
  Given "a file named \"features/support/env.rb\" with:", <<EOF
require File.dirname(__FILE__) + '/../../../../lib/cucumber/formatter/cuke_writer'
require File.dirname(__FILE__) + '/../../../../lib/step_collector'
require File.dirname(__FILE__) + '/../../../../lib/serial_number'

SerialNumber.number = "P123456"
EOF
end

When /^I run the "([^"]*)" feature$/ do |feature_name|
    When "I run \`cucumber features/#{feature_name}.feature -f Cucumber::Formatter::CukeWriter -o cuke_writer.txt -f progress\`"
end
