lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'multi_daemons/version'

Gem::Specification.new do |spec|
  spec.name          = 'multi_daemons'
  spec.version       = MultiDaemons::VERSION
  spec.authors       = ['santhanakarthikeyan']
  spec.email         = ['santhanakarthikeyan.s@gmail.com']

  spec.summary       = 'MultiDaemon provides an wrapper to run multiple daemon scripts'
  spec.description   = 'MultiDaemon provides an warpper to run multiple daemon scripts which can be controlled by start/stop and restart commands'
  spec.homepage      = %q{https://github.com/santhanakarthikeyan/multi_daemons}
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'byebug', ' ~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'mocha', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
end
