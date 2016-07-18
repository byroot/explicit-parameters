require 'action_pack/version'

module ExplicitParameters
  IS_RAILS5 = ActionPack.version >= Gem::Version.new('5.0.0')
  BaseError = Class.new(StandardError)
  InvalidParameters = Class.new(BaseError)
end

require 'explicit_parameters/version'
require 'explicit_parameters/parameters'
require 'explicit_parameters/controller'

require 'explicit_parameters/railtie' if defined? Rails
