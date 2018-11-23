require 'test_helper'

describe MultiDaemons::Controller do
  let(:daemon) { MultiDaemons::Daemon.new(proc {}, type: :proc, name: 'test') }
  let(:controller) { MultiDaemons::Controller.new([daemon]) }
  let(:controller_with_timeout) { MultiDaemons::Controller.new([daemon], force_kill_timeout: 10) }
  let(:controller_with_two_daemons) { MultiDaemons::Controller.new([daemon, daemon]) }

  describe '#start' do
    it 'should start daemons' do
      MultiDaemons::Daemon.any_instance.expects(:start).once
      controller.start
    end

    it 'should start multiple daemons' do
      MultiDaemons::Daemon.any_instance.expects(:start).twice
      controller_with_two_daemons.start
    end
  end

  describe '#stop' do
    it 'should stop daemon' do
      MultiDaemons::Daemon.any_instance.expects(:stop).once
      controller.stop
    end

    it 'should set multiple option' do
      daemon.multiple.must_be_nil
      controller.stop
      daemon.multiple.must_equal true
    end

    it 'should call force_kill and cleanup' do
      MultiDaemons::Pid.expects(:force_kill).once
      MultiDaemons::PidStore.expects(:cleanup).once
      controller.stop
    end

    it 'should pass force_timeout value' do
      MultiDaemons::Pid.expects(:force_kill).once
      controller_with_timeout.stop
    end
  end

  describe '#status' do
    it 'should return status of the daemon' do
      out, _err = capture_io do
        controller.status
      end
      out.strip.must_equal "test(): \e[31mDied\e[0m"
    end

    it 'should return running if daemon is running' do
      MultiDaemons::Pid.stubs(:running?).returns(true)
      out, _err = capture_io do
        controller.status
      end
      out.strip.must_equal "test(): \e[32mRunning\e[0m"
    end

    it 'should display pid is exist' do
      MultiDaemons::Daemon.any_instance.stubs(:pids).returns([123])
      out, _err = capture_io do
        controller.status
      end
      out.strip.must_equal "test(123): \e[31mDied\e[0m"
    end
  end
end
