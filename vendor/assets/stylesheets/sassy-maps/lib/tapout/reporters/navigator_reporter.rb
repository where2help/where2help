require 'tapout'
require 'tapout/reporters'

module Tapout
  module Reporters
    class NavigatorReporter < RuntimeReporter
      def backtrace_snippets(_test)
        ''
      end
    end
  end
end

Tapout::Reporters.index['navigator'] = Tapout::Reporters::NavigatorReporter
