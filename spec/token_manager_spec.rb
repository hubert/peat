require 'peat'
require 'active_support'
require 'active_support/core_ext'

module Peat
  describe TokenManager do
    before do
      test = Faraday.new(url: 'https://auth.exacttargetapis.com/v1/') do |builder|
        builder.adapter :test do |stub|
          stub.post('v1/requestToken') { |env|
            [ 200, {},  {'accessToken' => 'foobar123' }]
          }
        end
      end
      allow(TokenManager).to receive(:connection).and_return(test)
    end

    after do
      TokenManager.instance_variable_set('@token', nil)
    end

    context 'configuring fuel client id and secret' do
      context 'no creds set' do
        it 'raises MissingConfiguration if no fuel credentials set' do
          expect { Peat::TokenManager.token }.to raise_error(MissingConfiguration, 'You must set values for fuel client id and secret')
        end
      end

      context 'client and secret passed in' do
        it 'uses passed in client and secret' do
          expect { Peat::TokenManager.token(fuel_client_id: 'foo', fuel_secret: 'bar') }.not_to raise_error
        end
      end

      context 'client and secret set in env' do
        around(:each) do |example|
          ENV['FUEL_CLIENT_ID'] = 'foo'
          ENV['FUEL_SECRET'] = 'bar'
          example.run
          ENV['FUEL_CLIENT_ID'] = nil
          ENV['FUEL_SECRET'] = nil
        end

        it 'uses FUEL_CLIENT_ID and FUEL_SECRET from env if not passed in values' do
          expect { Peat::TokenManager.token }.not_to raise_error
        end
      end

      context 'client and secret set globally' do
        around(:each) do |example|
          $fuel_client_id, $fuel_secret = %w(foo bar)
          example.run
          $fuel_client_id, $fuel_secret = %w(nil nil)
        end

        it 'uses global $fuel_client_id and $fuel_secret if no values passed in or set in env' do
          expect { Peat::TokenManager.token }.not_to raise_error
        end
      end
    end

    context 'token is nil' do
      it 'fetches token' do
        expect(TokenManager.token).to eq('foobar123')
      end
    end

    context 'token is expired' do
      before do
        TokenManager.instance_variable_set('@token', { 'accessToken' => 'expired', 'created_at' => 1.hour.ago })
      end

      it 'fetches token' do
        expect(TokenManager.token).to eq('foobar123')
      end
    end

    context 'token is present and not expired' do
      before
      token = { 'accessToken' => 'valid', 'created_at' => 1.day.from_now }
      TokenManager.instance_variable_set('@token', token)
    end

    it 'returns token' do
      expect(TokenManager.token).to eql('valid')
    end
  end

end
