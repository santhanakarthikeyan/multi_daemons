require 'test_helper'

describe MultiDaemons do
  it 'should return latest version number' do
    MultiDaemons::VERSION.must_equal '0.1.2'
  end
end
