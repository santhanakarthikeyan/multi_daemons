module MultiDaemons
  # To control daemons
  class Controller
    attr_accessor :daemons, :options

    def initialize(daemons, options = {})
      @daemons = daemons
      @options = options
      unless ARGV[1].to_s.empty?
        @daemons = filter_daemons(daemons)
        msg = "Daemon [#{ARGV[1]}] not exist."\
              " Available ones are #{daemons.map(&:name)}"
        Log.log msg if @daemons.empty?
      end
    end

    def start
      daemons.each(&:start)
    end

    def stop
      pids = []
      pid_files = []
      daemons.each do |daemon|
        daemon.multiple = true
        daemon.stop
        pids << daemon.pids
        pid_files << daemon.pid_file
      end
      Pid.force_kill(pids.flatten, force_kill_timeout)
      PidStore.cleanup(pid_files)
    end

    def status
      daemon_attrs = {}
      daemons.each do |daemon|
        daemon.pids.each { |pid| daemon_attrs["#{daemon.name}-#{pid}"] = pid }
      end
      daemon_attrs.each do |pid_name, pid|
        puts "#{pid_name}: #{print_status(Pid.running?(pid))}"
      end
    end

    private

    def filter_daemons(daemons)
      daemon_names = ARGV[1].split(',')
      daemons.select { |v| daemon_names.include?(v.name) }
    end

    def print_status(status)
      status ? green('Running') : red('Died')
    end

    def green(msg)
      "\e[32m#{msg}\e[0m"
    end

    def red(msg)
      "\e[31m#{msg}\e[0m"
    end

    def force_kill_timeout
      options[:force_kill_timeout] || 30
    end
  end
end
