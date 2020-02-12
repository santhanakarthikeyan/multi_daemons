require 'test_helper'

describe MultiDaemons do
  it 'should return latest version number' do
    MultiDaemons::VERSION.must_equal '1.0.1'
  end
end
