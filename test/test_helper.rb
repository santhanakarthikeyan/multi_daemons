# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'multi_daemons'

require 'minitest/autorun'
require 'minitest/mock'
require 'mocha/minitest'

SimpleCov.minimum_coverage 99.27
