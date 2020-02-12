module MultiDaemons
  class ErrorReporter
    attr_accessor :reporters

    def self.report(exception, context_hash = {})
      MultiDaemons.error_reporters.compact.each do |reporter|
        begin
          reporter.call(exception, self, context_hash)
        rescue => inner_exception
          Log.log inner_exception
          backtrace = inner_exception.backtrace.join("\n")
          Log.log backtrace unless inner_exception.backtrace
        end
      end
    end
  end
end
