module MultiDaemons
  class Daemon
    KILL_TIMEOUT = 30
    attr_accessor :daemon, :type, :name, :options, :multiple, :errors

    def initialize(daemon, name:, type:, options: {})
      @daemon   = daemon
      @name     = name
      @type     = type
      @options  = options
      raise unless Validate.valid_daemon?(self)
    end

    def start
      case type
      when :proc, 'proc'
        safe_fork do
          daemon.call
        end
      when :script, 'script'
        safe_fork do
          Kernel.exec(daemon)
        end
      else
        puts 'Unsupported type'
      end
    end

    def stop
      if File.file?(pid_file)
        pids.each do |pid|
          begin
            Process.kill('TERM', pid)
          rescue Errno::ESRCH => e
            puts "#{e} #{pid}"
          end
        end

        return if multiple

        Pid.force_kill(pids, options[:force_kill_timeout])
        PidStore.cleanup(pid_file)
      else
        puts 'Pid file not found. Is daemon running?'
      end
    end

    def pids
      PidStore.get(pid_file)
    end

    def pid_file
      "#{pid_dir}#{name}.pid"
    end

    private

    def log_file
      "#{log_dir}#{name}.log"
    end

    def safe_fork
      Process.fork do
        begin
          Process.setsid

          $0 = name || $PROGRAM_NAME

          PidStore.store(pid_file, Process.pid)

          log = File.new(log_file, 'a')
          STDIN.reopen '/dev/null'
          STDOUT.reopen log
          STDERR.reopen STDOUT

          yield
        rescue Exception => e
          puts e
        end
      end
    end

    def log_dir
      return '' if options[:log_dir].to_s.empty?

      options[:log_dir][-1] == '/' ? options[:log_dir] : "#{options[:log_dir]}/"
    end

    def pid_dir
      return '' if options[:pid_dir].to_s.empty?

      options[:pid_dir][-1] == '/' ? options[:pid_dir] : "#{options[:pid_dir]}/"
    end
  end
end
