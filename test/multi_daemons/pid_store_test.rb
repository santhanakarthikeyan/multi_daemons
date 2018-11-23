require 'test_helper'

describe MultiDaemons::PidStore do
  let(:pid_file) { 'test.pid' }

  before(:each) do
    FileUtils.rm_f(pid_file) if File.exist?(pid_file)
  end

  after(:each) do
    FileUtils.rm_f(pid_file) if File.exist?(pid_file)
  end

  describe '.store' do
    it 'should write into the file' do
      MultiDaemons::PidStore.store(pid_file, 1)
      File.exist?(pid_file).must_equal true
      File.read(pid_file).strip.must_equal '1'
    end
  end

  describe 'get' do
    it 'should get pids from file' do
      File.open(pid_file, 'a') { |f| f << '123' }
      MultiDaemons::PidStore.get(pid_file).must_equal [123]
    end

    it 'should get multiple pids' do
      File.open(pid_file, 'a') { |f| f << "123\n456" }
      MultiDaemons::PidStore.get(pid_file).must_equal [123, 456]
    end
  end

  describe '.cleanup' do
    it 'should remove file' do
      File.open(pid_file, 'a') { |f| f << '123' }
      File.exist?(pid_file).must_equal true
      MultiDaemons::PidStore.cleanup(pid_file)
      File.exist?(pid_file).must_equal false
    end
  end
end
