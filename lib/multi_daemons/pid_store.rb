module MultiDaemons
  module PidStore
    def self.store(file_name, pid)
      File.open(file_name, 'a') { |f| f << "#{pid}\n" }
    end

    def self.get(file_name)
      [].tap do |pids|
        unless File.exist?(file_name)
          pids << nil
          next
        end
        File.read(file_name).each_line do |line|
          pids << line.to_i
        end
      end
    end

    def self.cleanup(file_names)
      file_names = [file_names].flatten
      file_names.each do |file_name|
        next unless File.exist?(file_name)

        FileUtils.rm(file_name)
      end
    end
  end
end
