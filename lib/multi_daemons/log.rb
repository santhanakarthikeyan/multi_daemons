# frozen_string_literal: true

module MultiDaemons
  # To add log entries
  module Log
    class << self
      def log(msg)
        puts "#{Time.now} #{msg}"
      end
    end
  end
end
