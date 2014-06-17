require 'peat'
require 'active_support/core_ext'

module Peat
  describe TokenManager do
    context 'token is nil' do
      it 'fetches token' do
        expect(TokenManager).to receive(:fetch_token)
        TokenManager.token
      end
    end

    context 'token is expired' do
      it 'fetches token' do
        TokenManager.instance_variable_set('@token', { 'created_at' => 1.hour.ago })
        expect(TokenManager).to receive(:fetch_token)
        TokenManager.token
      end
    end

    context 'token is present and not expired' do
      it 'returns token' do
        token = { 'accessToken' => 'foobar123', 'created_at' => 1.day.from_now }
        TokenManager.instance_variable_set('@token', token)
        expect(TokenManager.token).to eql('foobar123')
      end
    end
  end
end
