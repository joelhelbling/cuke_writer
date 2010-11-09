require 'fileutils'
require File.dirname(__FILE__) + '/../../step_collector'
require File.dirname(__FILE__) + '/../../serial_number'

module Cucumber
  module Ast
    class Feature
      def filename
        @file.gsub(/^.*\//, '').gsub(/\.feature$/, '.cw.feature')
      end
    end
  end
  module Formatter
    class CukeWriter

      def initialize(step_mother, path_or_io, options)
        @options = options
        @meta_dir = 'generated_features'
        @step_collector = StepCollector.new
        @current_scenario_outline_heading = nil
      end

      def after_feature(feature)
        if @step_collector.steps.size > 0
          FileUtils.mkdir_p(output_directory) unless File.directory?(output_directory)
          File.open("#{output_directory}/#{feature.filename}", 'w') do |fh|
            fh.write "Feature: #{feature.name}\n  [generated from #{feature.file}]\n"
            fh.write @step_collector.steps.join("\n") + "\n"
          end
        end
        @step_collector.reset
      end

      def scenario_name(keyword, name, file_colon_line, source_indent)
        @step_collector.add_scenario "#{keyword}: #{name}\n    [from #{file_colon_line}]", 2
      end

      def background_name(keyword, name, file_colon_line, source_indent)
        @step_collector.add_scenario "#{keyword}: #{name}\n    [from #{file_colon_line}]", 2
      end

      private

      def output_directory
        "features/#{@meta_dir}/#{SerialNumber}"
      end
    end
  end
end
