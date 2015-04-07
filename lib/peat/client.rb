require 'faraday_middleware'

module Peat
  module Client
    module_function

    def connection
      @connection ||= Faraday.new(url: "https://www.exacttargetapis.com/messaging/v1/") do |conn|
        conn.request :json

        conn.response :logger

        conn.adapter Faraday.default_adapter
      end
    end

    def deliver(trigger_name, params) 
      resp = connection.post do |req|
        req.url "messageDefinitionSends/key:#{trigger_name}/send"
        req.headers['Content-Type'] = 'application/json'
        req.headers['Authorization'] = "Bearer #{Peat::TokenManager.token}"
        req.body = params.to_json
      end

      resp.success?
    end
  end
end
