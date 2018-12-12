# require 'multi_daemons/version'
require_relative 'multi_daemons/controller'
require_relative 'multi_daemons/configuration'
require_relative 'multi_daemons/daemon'
require_relative 'multi_daemons/error_reporter'
require_relative 'multi_daemons/pid_store'
require_relative 'multi_daemons/pid'
require_relative 'multi_daemons/validate'
require 'fileutils'
require 'byebug'
require 'timeout'

module MultiDaemons
  CONFIG = Configuration.new

  def self.runner(daemons, options = {})
    raise unless Validate.valid_multi_daemon?(daemons)

    controller = Controller.new(daemons, options)
    daemonize(controller)
  end

  def self.error_reporters
    CONFIG.error_reporters
  end

  def self.error_reporters=(reporters)
    CONFIG.error_reporters = reporters
  end

  def self.daemonize(controller)
    case !ARGV.empty? && ARGV[0]
    when 'start'
      controller.start
    when 'stop'
      controller.stop
    when 'restart'
      controller.stop
      controller.start
    when 'status'
      controller.status
    else
      raise 'Invalid argument. Specify start, stop or restart'
    end
  end
end
