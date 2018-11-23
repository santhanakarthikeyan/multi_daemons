require 'test_helper'

describe MultiDaemons do
  let(:daemon) { MultiDaemons::Daemon.new(proc {}, type: :proc, name: 'test') }
  let(:runner) { MultiDaemons.runner([daemon], force_kill_timeout: 10) }
  let(:runner_without_options) { MultiDaemons.runner([daemon]) }

  describe '.runner' do
    it 'should raise RuntimeError when ARGV not match' do
      -> { MultiDaemons.runner([], force_kill_timeout: 10) }.must_raise RuntimeError
    end

    it 'should start' do
      MultiDaemons::Controller.any_instance.expects(:start).once
      ARGV[0] = 'start'
      runner
      ARGV[0] = nil
    end

    it 'should stop' do
      MultiDaemons::Controller.any_instance.expects(:stop).once
      ARGV[0] = 'stop'
      runner
      ARGV[0] = nil
    end

    it 'should show status' do
      MultiDaemons::Controller.any_instance.expects(:status).once
      ARGV[0] = 'status'
      runner
      ARGV[0] = nil
    end

    it 'should start' do
      MultiDaemons::Controller.any_instance.expects(:start).once
      MultiDaemons::Controller.any_instance.expects(:stop).once
      ARGV[0] = 'restart'
      runner
      ARGV[0] = nil
    end

    it 'options are optional' do
      MultiDaemons::Controller.any_instance.expects(:start).once
      ARGV[0] = 'start'
      runner
      ARGV[0] = nil
    end

    it 'should raise error when daemons are empty' do
      -> { MultiDaemons.runner([]) }.must_raise RuntimeError, 'Daemons are not present or invalid'
    end

    it 'should raise error when daemons are nil' do
      -> { MultiDaemons.runner(nil) }.must_raise RuntimeError, 'Daemons are not present or invalid'
    end

    it 'should raise error when daemons are not a daemon class' do
      -> { MultiDaemons.runner(['']) }.must_raise RuntimeError, 'Daemons are not present or invalid'
    end
  end
end
