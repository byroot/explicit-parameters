module ExplicitParameters
  BaseError = Class.new(StandardError)
  InvalidParameters = Class.new(BaseError)
end

require 'explicit_parameters/version'
require 'explicit_parameters/parameters'
require 'explicit_parameters/controller'

require 'explicit_parameters/railtie' if defined? Rails
