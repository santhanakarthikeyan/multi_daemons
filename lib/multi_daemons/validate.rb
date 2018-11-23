module MultiDaemons
  class Validate
    class << self
      def valid_daemon?(daemon)
        name = daemon.name
        return daemon_name_error unless name && name.length > 1

        daemon.name = name.to_s if name.is_a?(Symbol)
        case daemon.type
        when :proc, 'proc'
          return daemon_proc_error unless daemon.daemon.is_a?(Proc)
        end
        true
      end

      def valid_multi_daemon?(multi_daemon)
        if multi_daemon.is_a?(Array) && !multi_daemon.empty?
          if multi_daemon.all? { |daemon| daemon.is_a?(MultiDaemons::Daemon) }
            return true
          end
        end
        invalid_multi_daemon_option
        false
      end

      private

      def invalid_multi_daemon_option
        puts 'Daemons are not present or invalid'
      end

      def daemon_name_error
        puts 'Daemon name should not be empty'
        false
      end

      def daemon_proc_error
        puts 'Daemons type is proc but proc block has not been passed'
        false
      end
    end
  end
end
