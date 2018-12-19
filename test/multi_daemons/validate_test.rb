# frozen_string_literal: true

require 'test_helper'

describe MultiDaemons::Validate do
  let(:proc_daemon) do
    MultiDaemons::Daemon.new(proc { puts 'daemon_test started' },
                             name: 'daemon_test',
                             type: :proc)
  end

  it 'should validate daemon' do
    MultiDaemons::Validate.valid_daemon?(proc_daemon).must_equal true
  end

  it 'should return false if name is empty' do
    proc_daemon.name = nil
    MultiDaemons::Validate.valid_daemon?(proc_daemon).must_equal false
  end

  it 'should fail even name is empty' do
    proc_daemon.name = ''
    MultiDaemons::Validate.valid_daemon?(proc_daemon).must_equal false
  end

  it 'should fail if we not pass a proc' do
    proc_daemon.daemon = nil
    MultiDaemons::Validate.valid_daemon?(proc_daemon).must_equal false
  end
end
