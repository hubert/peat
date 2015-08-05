require 'vcr'
VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock # or :fakeweb
  #c.allow_http_connections_when_no_cassette = true
  c.default_cassette_options = {
    match_requests_on: [:method, :path],
    allow_playback_repeats: true,
  }
end

require 'faraday_middleware'

require 'peat'
