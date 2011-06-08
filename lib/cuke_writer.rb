require 'fileutils'
require File.dirname(__FILE__) + '/step_collector'
require File.dirname(__FILE__) + '/serial_number'
require File.dirname(__FILE__) + '/cucumber_ast_feature'

module CukeWriter
  class Formatter

    def initialize(step_mother, path_or_io, options)
      @options = options
      @meta_dir = 'generated_features'
      @step_collector = StepCollector.new
      @current_scenario_outline_heading = nil
      @scenario_outline_name = nil
      @currently_in_examples_table = false
    end

    def after_feature(feature)
      if @step_collector.steps.size > 0
        FileUtils.mkdir_p(output_directory) unless File.directory?(output_directory)
        File.open("#{output_directory}/#{feature.filename}", 'w') do |fh|
          fh.write "@cuke_writer\nFeature: #{feature.name}\n  [generated from #{feature.file}]\n"
          fh.write @step_collector.steps.join("\n") + "\n"
        end
      end
      @step_collector.reset
    end

    def scenario_name(keyword, name, file_colon_line, source_indent)
      if keyword == 'Scenario Outline'
        @scenario_outline_info = {:name => name, :file => file_colon_line.gsub(/:\d+$/, '')}
      else
        @step_collector.add_scenario "#{keyword}: #{name}\n    [from #{file_colon_line}]", {:indent => 2}
      end
    end

    def background_name(keyword, name, file_colon_line, source_indent)
      @step_collector.add_scenario "#{keyword}: #{name}\n    [from #{file_colon_line}]", {:indent => 2}
    end

    def examples_name(*args)
      @currently_in_examples_table = true
    end

    def after_examples(*args)
      @scenario_outline_name = nil
      @currently_in_examples_table = false
    end

    def before_table_row(table_row)
      if @currently_in_examples_table
        @step_collector.add_scenario("Scenario: #{@scenario_outline_info[:name]}\n    [from #{@scenario_outline_info[:file]}:#{table_row.line}]", {:indent => 2})
      end
    end

    private

    def output_directory
      "features/#{@meta_dir}/#{SerialNumber}"
    end
  end
end
