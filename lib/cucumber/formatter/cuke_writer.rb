require 'fileutils'
require File.dirname(__FILE__) + '/../../step_collector'
require File.dirname(__FILE__) + '/../../serial_number'

module Cucumber
  module Ast
    class Feature
      def filename
        @file.gsub(/^.*\//, '')
      end
    end
  end
  module Formatter
    class CukeWriter

      def initialize(step_mother, path_or_io, options)
        @options = options
        @meta_dir = 'generated_features'
        @step_collector = StepCollector.new
      end

      def after_feature(feature)
        if @step_collector.steps.size > 0
          FileUtils.mkdir_p(output_directory) unless File.directory?(output_directory)
          File.open("#{output_directory}/#{feature.filename}", 'w') do |fh|
            fh.write @step_collector.steps.join("\n")
          end
        end
        @step_collector.reset
      end

      private

      def output_directory
        "features/#{@meta_dir}/#{SerialNumber}"
      end
    end
  end
end
