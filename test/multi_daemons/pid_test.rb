require 'test_helper'

describe MultiDaemons::Pid do
  describe '.running?' do
    it 'should return true if process is running' do
      MultiDaemons::Pid.running?(Process.pid).must_equal true
    end

    describe 'return false' do
      it 'when pid is nil' do
        MultiDaemons::Pid.running?(nil).must_equal false
      end

      it 'when pid out of range' do
        MultiDaemons::Pid.running?(123_456_789).must_equal false
      end
    end
  end

  describe '.force_kill' do
    it 'should stop when process not running' do
      MultiDaemons::Pid.stubs(:running?).returns(false)
      MultiDaemons::Pid.stubs(:force_kill_timeout).returns(2)
      MultiDaemons::Pid.stubs(:default_timeout).returns(2)
      MultiDaemons::Pid.force_kill([123]).must_equal true
    end

    it 'should force kill' do
      MultiDaemons::Pid.stubs(:running?).returns(true)
      MultiDaemons::Pid.stubs(:force_kill_timeout).returns(2)
      MultiDaemons::Pid.stubs(:default_timeout).returns(2)
      Process.expects(:kill).once
      MultiDaemons::Pid.force_kill([123]).must_equal false
    end
  end
end
