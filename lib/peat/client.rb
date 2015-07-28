module Peat
  class Client

    def initialize(middleware: [], adapter: Faraday.default_adapter)
      @middleware = middleware
      @adapter = adapter
    end

    def connection
      @connection ||= Faraday.new(url: "https://www.exacttargetapis.com/messaging/v1/") do |conn|
        conn.request :json

        @middleware.each { |m| conn.use m }

        conn.adapter @adapter
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

    def deliver!(trigger_name, params)
      deliver(trigger_name, params) or raise Peat::DeliveryFailed
    end
  end
end
