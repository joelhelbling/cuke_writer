CukeWriter
==========

[![Build Status](http://Travis-ci.org/joelhelbling/cuke_writer.png)](http://Travis-ci.org/joelhelbling/cuke_writer)


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

_This just in!  If your *generating* feature has a Background section which has steps which
generate steps, then the *generated* feature will also have a Background section which 
contains those generated background steps._

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

Wait, What About Scenario Outlines?
-----------------------------

So glad you asked.  When CukeWriter encounters a scenario outline/example table in your 
feature, it generates a separate regular ole Scenario:&trade; for each row in your examples
table, and references the line number of the corresponding example table row.

Early on, I figured I'd have CukeWriter just output a corresponding Scenario Outline:&trade;,
but as I thought about it, I realized that to assume the steps you generate from one example
row could very well be different from the steps generated from another example row.  For
example:

    Feature: As a music fan,
      In order to make the most of a rock star spotting,
      I want to adapt to each rock star differently
      So that I can get an autograph

      Scenario Outline: This is it
        Given I see "<rock_star>"

      Examples:
        | rock_star  |
        | Ringo      |
        | Sting      |
        | Ted Nugent |

And suppose you wanted this to generate different steps for different stars?  Here's an
example of what we _can_ do:

    Feature: As a music fan,
      In order to make the most of a rock star spotting,
      I want to adapt to each rock star differently
      So that I can get an autograph
      [generated from features/rock_star_recognition.feature]
      
      Scenario: This is it
        [from features/rock_star_recognition.feature:8]
        Given "Ringo" sees me
        Then I say "Cheers!"
      
      Scenario: This is it
        [from features/rock_star_recognition.feature:9]
        Given Sting is in an elevator
        When I say "De do do do, de da da da!"
        Then Sting says "I just remembered, I've got some business on 85."
      
      Scenario: This is it
        [from features/rock_star_recognition.feature:10]
        Given Ted Nugent sees me
        Then I run the other way

All this unique handling of each brush with greatness becomes impossible if we just generate
a single scenario outline.

Step Tables
-----------

Sometimes you just want to have CukeWriter generate a step which has a table attached to it.  And
that's ok.  `StepCollector#add` now accepts a hash as an optional second parameter, and in that
hash you can send over a `:table` (in the form of a `Cucumber::Ast::Table`).  Behold:

    Given I have a step with the following table:
      | THAT  | THOSE     |
      | thing | things    |
      | there | overthere |

...and supposing your step defintion did this:

    Given /^I have a step with the following table:$/ |table|
      @step_collector.add "Then this table goes here:", {:table => table}
    end

...then your generated cuke would have this step (and attendant table):

    Then this table goes here:
      | THAT  | THOSE     |
      | thing | things    |
      | there | overthere |

Of course, you don't have to just pass a table straight through.  You can certainly just generate
your own table, e.g.

    table = Cucumber::Ast::Table.new [['GOO', 'GAH'], ['boo', 'bah']]

Now that you can generate step tables, why, go forth, and multiply!

Keep 'Em Seperated
------------------

If you're using CukeWriter to solve some kind of temporal distortion problem (a.k.a. an asynchronous
problem) then chances good that when you want to run the features that use CukeWriter to write 
features, you _don't_ want to run the features that CukeWriter has generated...and vice versa.
Accordingly, CukeWriter puts a "@cuke_writer" tag on each feature that it generates.  This makes it
easy to tell cucumber which kind of Cuke is in season now.  When it's time to plant nice neat rows
of burpless seedlings, you can make Cucumber skip any CukeWriter-generated cukes with this:

    cucumber --tags ~@cuke_writer

And when it's time to turn our attention to the nice new crop of CukeWriter-written cukes, you can
load 'em up for the county fair with this:

    cucumber --tags @cuke_writer

Thus CukeWriter uses Cucumber tags to heal rifts in the time-space continuum, which is pretty
freakin' sweet.

Suggestion: you might be able to simplify your personal journey by putting all this `--tags ~@cuke_writer`
and `--tags @cuke_writer` stuff into your cucumber.yml.  For instance:

    default: --tags ~@cuke_writer     # avoid running CW-generated cukes
    cuke_writer: --tags @cuke_writer  # run *only* CW-generated cukes

This seems like a very helpful suggestion if I do say so myself.  Someday I will make CukeWriter
glance at your cucumber.yml and suggest this very same suggestion which I have suggested.  Unless, of
course, you have already followed this suggestion, in which case CukeWriter will wink at you and 
smile knowingly, like this: ;)

What CukeWriter Won't Do
------------------------

_I would do anything for love, but I won't do that. --Meatloaf_

CukeWriter will not kick off the generated batch of cucumber tests automatically.  This is because
the mechanism for doing that will likely be different depending on the requirements of your project
and operating environment in which CukeWriter is used:  it could be triggered by cron, your CI server,
or a Windows scheduled task.  It could be scheduled for five minutes from now, or fifty years from
now.  Or it could be run manually whenever you darn well please.  So let's leave the "when" and 
"how" details in your hands.

It also won't generate the step definitions you'll need for running your generated features.  You'll
want to write those yourself since they're so important!

What It _Will_ Do Soon
--------------------

Here's a nice, shallow backlog:

 *   _Output "Background" section (only if background steps generate steps)_ ...[DONE]
 *   _Handle scenario outlines_ ...[DONE]
 *   _Handle step tables_ ...[DONE]
 *   _Need a test which actually runs generated features to ensure they are kopasetic._ ...[DONE]
 *   _Need a special tag (e.g. @cuke_writer) which is added to each generated feature.  This will allow
     us to (re)run the main features while omitting the generated features and vice versa._ ...[DONE]
 *   Have CW glance at cucumber.yml and suggest a couple of changes for working with/around
     the @cw tag (unluss cucumber.yml already does so).
 *   Generate a nice new rake task for each serialized batch of generated features.
 *   Create a nice rake task which cleans up old batches of generated features.
 *   Turn CukeWriter into a gem.

