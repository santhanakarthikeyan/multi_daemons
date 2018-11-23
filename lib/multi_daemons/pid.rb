module MultiDaemons
  class Pid
    KILL_TIMEOUT = 30

    def self.running?(pid)
      return false unless pid

      begin
        Process.kill(0, pid)
        return true
      rescue Errno::ESRCH
        return false
      rescue Exception
        return true
      end
    end

    def self.force_kill(pids, timeout = KILL_TIMEOUT)
      Timeout.timeout(force_kill_timeout(timeout), Timeout::Error) do
        pids.each do |pid|
          sleep(0.5) while Pid.running?(pid)
        end
      end
      true
    rescue Timeout::Error
      puts 'Force stopping processes'
      pids.each do |pid|
        begin
          Process.kill('KILL', pid)
        rescue Errno::ESRCH
        end
      end

      begin
        Timeout.timeout(default_timeout, Timeout::Error) do
          pids.each do |pid|
            sleep 1 while Pid.running?(pid)
          end
        end
      rescue Timeout::Error
        puts 'Can not stop processes'
        return false
      end
    end

    def self.force_kill_timeout(timeout)
      timeout || KILL_TIMEOUT
    end

    def self.default_timeout
      KILL_TIMEOUT
    end
  end
end
