CukeWriter
==========

What is it?
-----------

CukeWriter is a custom Cucumber formatter which generates serialized sets of Cucumber features.

To use it:

    cucumber --format Cucumber::Formatter::CukeWriter features

CukeWriter basically creates features and scenarios which correspond directly to the features
and scenarios that generated them.  You'll need to instantiate a step collector:

    @step_collector = StepCollector.new

Now suppose we have a feature called features/awesome.feature:

    Feature: Let's write some cukes
    
      Scenario: Just one step, but boy, what a step
        Given I put all my eggs in one basket

Then, in any of your step definitions, you do summa this:

    Given /^I put all my eggs in one basket$/ do
      @step_collector.add "Given I have hadoop report \"R#{SerialNumber}.html.gz\""
      @step_collector.add "When I uncompress the hadoop report"
      @step_collector.add "Then I should see \"All files processed\""
    end

Each collected step is added to a scenario/feature which has the same name as the scenario
which had the step which collected that step.  So in this example, CukeWriter would create
a feature called features/generated_features/20101122131415/awesome.cw.feature (where the
serial number for this run was 20101122131415):

    Feature: Let's write some cukes
      [generated from features/awesome.feature]
    
      Scenario: Just one step, but boy, what a step
        [from features/awesome.feature:3]
        Given I have hadoop report "R20101122131415.html.gz"
        When I uncompress the hadoop report
        Then I should see "All files processed"

If a scenario did not have any collected steps, it will not be added to its corresponding
generated feature.  If a feature did not have any generated scenarios, it will not generate
a CukeWriter feature.

Why Would You Want This?
------------------------

Suppose you are using Cucumber to test an asynchronous system which generates artifacts which won't
be available for some time after your Cucumber tests run.  CukeWriter allows you to generate a
serial-number-tagged set of Cucumber features which can be run at some later time.

For example, suppose you wish to test an email messaging system which uses a third-party email
service provider which takes its sweet ole time getting those messages into an actual email inbox.
Each time you run your main features, you send a new batch of emails out.  You could tag each email
with the serial number of that particular run, so that when you run the generated features, they
will test the specific set of emails which were generated in the corresponding execution of the
main features.

What It Won't Do
----------------

CukeWriter will not kick off the generated batch of cucumber tests automatically.  This is because
the mechanism for doing that will likely be different depending on the requirements of your project
and operating environment in which CukeWriter is used:  it could be triggered by cron, your CI server,
or a Windows scheduled task.  It could be scheduled for five minutes from now, or fifty years from
now.  Or it could be run manually whenever you darn well please.  So we're leaving the "when" and 
"how" details in your hands.

What It _Will_ Do Soon
--------------------

Here's a nice, shallow backlog:
 *   Output "Background" section (only if background steps generate steps).
 *   Handle scenario outlines.
 *   Handle step tables (just pass 'em on wholesale to the generated step).
 *   Need a test which actually runs generated features to ensure they are kopasetic.
 *   Need a special tag (e.g. @cw) which is appended to each generated feature.  This will allow
     us to (re)run the main features while omitting the generated features and vice versa.
 *   Generate a nice new rake task for each serialized batch of generated features.
 *   Create a nice rake task which cleans up old batches of generated features.
 *   Turn CukeWriter into a gem.

