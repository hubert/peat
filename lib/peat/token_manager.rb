module Peat
  module TokenManager
    module_function

      def token(fuel_client_id: nil, fuel_secret: nil)
        fetch_token do
          client_id = fuel_client_id || ENV['FUEL_CLIENT_ID'] || $fuel_client_id
          secret = fuel_secret || ENV['FUEL_SECRET'] || $fuel_secret
          connection.post do |req|
            req.url 'requestToken'
            req.headers['Content-Type'] = 'application/json'
            req.body = {
              'clientId' => client_id,
              'clientSecret' => secret,
            }.to_json
          end.body.merge('created_at' => Time.now)
        end
      end

      def connection
        @connection = Faraday.new(url: 'https://auth.exacttargetapis.com/v1/') do |conn|
          conn.request :json

          conn.response :logger
          conn.response :json, :content_type => /\bjson$/

          conn.adapter Faraday.default_adapter
        end
      end

      def token_expired?
        # token is good for an hour, but to be safe...
        Time.now > 50.minutes.since(@token['created_at']) 
      end

      def fetch_token
        if @token && !token_expired?
          @token['accessToken']
        else
          @token = yield
          @token['accessToken']
        end
      end
  end
end
