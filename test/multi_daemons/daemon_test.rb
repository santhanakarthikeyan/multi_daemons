require 'test_helper'

describe MultiDaemons::Daemon do
  let(:script_daemon) { MultiDaemons::Daemon.new('bash ' + File.expand_path('../scripts/test_daemon_script.sh', __dir__), name: 'daemon_test', type: :script) }
  let(:proc_daemon) { MultiDaemons::Daemon.new(proc { puts 'daemon_test started' }, name: 'daemon_test', type: :proc, options: { log_dir: '.', pid_dir: '.' }) }
  let(:long_runing_proc_daemon) { MultiDaemons::Daemon.new(proc { sleep 5 }, name: 'daemon_test', type: :proc) }
  let(:throw_exception_proc) { MultiDaemons::Daemon.new(proc { raise 'test exception' }, name: 'daemon_test', type: :proc) }
  let(:log_file) { proc_daemon.send(:log_file) }
  let(:pid_file) { proc_daemon.pid_file }
  before(:all) do
    MultiDaemons::Validate.stubs(:valid_daemon?).returns(true)
    FileUtils.rm(log_file) if File.exist?(log_file)
    FileUtils.rm(pid_file) if File.exist?(pid_file)
  end

  describe '#start' do
    describe 'proc daemon' do
      it 'should start a process' do
        proc_daemon.start
        sleep 2
        File.read(log_file).strip.must_equal 'daemon_test started'
        File.exist?(log_file).must_equal true
        pid = File.read(log_file).strip
        pid.wont_equal nil
        pid.length.must_be :>=, 1
      end

      it 'should set the process title' do
        long_runing_proc_daemon.start
        `ps -eaf | grep daemon_test | grep -v grep`.strip.must_match /daemon_test/
      end

      it 'should catch any exception raised inside the block' do
        throw_exception_proc.start
        sleep 1
        File.read(log_file).strip.must_match /test exception/
      end
    end

    describe 'script daemon' do
      it 'should start a process' do
        script_daemon.start
        sleep 1
        File.read(log_file).strip.must_equal 'test daemon script started'
      end
    end

    it 'should allow invalid type' do
      MultiDaemons::Daemon.any_instance.expects(:safe_fork).never
      proc_daemon.type = nil
      proc_daemon.start
    end

    it 'should invoke safe_fork' do
      Process.expects(:fork).once
      proc_daemon.start
    end
  end

  describe '#stop' do
    let(:proc_daemon) { MultiDaemons::Daemon.new(proc {}, name: 'daemon_test', type: :proc) }
    it 'should stop running process' do
      MultiDaemons::Pid.stubs(:force_kill_timeout).returns(2)
      MultiDaemons::Pid.stubs(:default_timeout).returns(2)
      File.exist?(pid_file).must_equal false
      proc_daemon.start
      sleep 1
      File.exist?(pid_file).must_equal true
      pid = File.read(pid_file).strip
      `ps -eaf | grep daemon_test | grep -v gre`.must_match /daemon_test/

      proc_daemon.stop
      sleep 1
      File.exist?(pid_file).must_equal false
    end

    it 'should warn if pid file not found' do
      File.stubs(:file?).returns(false)
      out, _err = capture_io do
        proc_daemon.stop
      end
      out.strip.must_equal 'Pid file not found. Is daemon running?'
    end

    it 'should capture ESRCH error while killing a job' do
      File.stubs(:file?).returns(true)
      Process.stubs(:kill).raises(Errno::ESRCH)
      proc_daemon.stop
    end
  end

  describe 'process_fork' do
    it 'should execute process_fork' do
      Process.expects(:setsid).once
      STDOUT.expects(:reopen).once
      STDIN.expects(:reopen).once
      STDERR.expects(:reopen).once
      proc_daemon.send(:process_fork)
    end

    it 'should capture any exception' do
      Process.stubs(:setsid).raises
      out, _err = capture_io do
        proc_daemon.send(:process_fork)
      end
    end
  end
end
