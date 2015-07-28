require "peat/version"
require 'faraday_middleware'

module Peat
  class MissingConfiguration < Exception; end
  class DeliveryFailed < RuntimeError; end

  autoload :TokenManager, 'peat/token_manager'
  autoload :Client, 'peat/client'
end
