module MultiDaemons
  class Configuration
    attr_writer :error_reporters

    def error_reporters
      @error_reporters.is_a?(Array) ? @error_reporters : [@error_reporters]
    end
  end
end
