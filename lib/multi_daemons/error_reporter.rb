module MultiDaemons
  class ErrorReporter
    attr_accessor :reporters

    def self.report(exception, context_hash = {})
      MultiDaemons.error_reporters.compact.each do |reporter|
        begin
          reporter.call(exception, self, context_hash)
        rescue Exception => inner_exception
          puts inner_exception
          puts inner_exception.backtrace.join("\n") unless inner_exception.backtrace
        end
      end
    end
  end
end
