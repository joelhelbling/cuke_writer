module Cucumber
  module Ast
    class Feature
      def filename
        @file.gsub(/^.*\//, '').gsub(/\.feature$/, '.cw.feature')
      end
    end
  end
end

