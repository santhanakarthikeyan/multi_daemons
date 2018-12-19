require 'test_helper'

describe MultiDaemons::ErrorReporter do
  it '.report' do
    class Airbrake; end
    Airbrake.expects(:notify).once
    MultiDaemons.error_reporters = [proc { |exception, _daemon, context_hsh| Airbrake.notify(exception, context_hsh) }]
    MultiDaemons::ErrorReporter.report(Exception.new, {})
  end

  it 'should capture exception' do
    class Airbrake; end
    MultiDaemons.error_reporters = [proc { |_exception, _daemon, _context_hsh| raise StandardError }]
    MultiDaemons::ErrorReporter.report(Exception.new, {})
  end
end
