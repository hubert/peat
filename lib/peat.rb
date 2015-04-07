require "peat/version"
require 'faraday_middleware'

module Peat
  autoload :TokenManager, 'peat/token_manager'
  autoload :Client, 'peat/client'
end
