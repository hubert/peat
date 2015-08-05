require 'spec_helper'

module Peat
  describe Client do
    before do
      FooMiddleware = Class.new(Faraday::Middleware) do
        def call(req_env)
          @app.call(req_env).on_complete do |resp_env|
            resp_env.status = 200
          end
        end
      end
    end

    describe '.deliver' do
      it 'proxies calls to peat client' do
        VCR.use_cassette 'peat' do
          expect(Peat::Client.deliver(:foo, {})).to be_falsey
        end
      end
    end

    describe '#deliver' do
      it 'allows configuration of middleware' do
        client = Peat::Client.new(middleware: [FooMiddleware])
        VCR.use_cassette 'peat' do
          expect(client.deliver!(:foo, {})).to be_truthy
        end
      end

      it 'defaults to no middleware' do
        client = Peat::Client.new
        VCR.use_cassette 'peat' do
          expect { client.deliver!(:foo, {}) }.to raise_exception Peat::DeliveryFailed
        end
      end
    end
  end
end
