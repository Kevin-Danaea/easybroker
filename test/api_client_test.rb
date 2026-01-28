require 'minitest/autorun'
require 'webmock/minitest'
require_relative '../lib/easy_broker'

class ApiClientTest < Minitest::Test
  def setup
    @api_key  = 'test_key'
    @base_url = 'https://api.stagingeb.com'
    @client   = EasyBroker::ApiClient.new(api_key: @api_key, base_url: @base_url)
  end

  def test_get_raises_on_non_success_response
    stub_request(:get, "#{@base_url}/v1/properties")
      .with(
        query: {},
        headers: {
          'X-Authorization' => @api_key,
          'Content-Type' => 'application/json'
        }
      )
      .to_return(status: 500, body: 'Server error')

    error = assert_raises(RuntimeError) do
      @client.get('/v1/properties')
    end

    assert_match(/API Error: 500/, error.message)
  end
end

