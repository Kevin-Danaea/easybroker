require 'minitest/autorun'
require 'webmock/minitest'
require_relative '../lib/easy_broker'

class PropertyRepositoryTest < Minitest::Test
  def setup
    @api_key = 'test_key'
    @base_url = 'https://api.stagingeb.com'
    @client = EasyBroker::ApiClient.new(api_key: @api_key, base_url: @base_url)
    @repository = EasyBroker::PropertyRepository.new(@client)
  end

  def test_find_all_fetches_all_pages
    # Mock Page 1
    stub_request(:get, "#{@base_url}/v1/properties")
      .with(
        query: { 'limit' => '50', 'page' => '1' },
        headers: { 'X-Authorization' => @api_key }
      )
      .to_return(
        status: 200,
        body: {
          content: [{ title: 'Property 1' }, { title: 'Property 2' }],
          pagination: { next_page: 2 }
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    # Mock Page 2 (Last Page)
    stub_request(:get, "#{@base_url}/v1/properties")
      .with(
        query: { 'limit' => '50', 'page' => '2' },
        headers: { 'X-Authorization' => @api_key }
      )
      .to_return(
        status: 200,
        body: {
          content: [{ title: 'Property 3' }],
          pagination: { next_page: nil }
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    properties = @repository.find_all

    assert_equal 3, properties.count
    assert_equal 'Property 1', properties[0].title
    assert_equal 'Property 3', properties[2].title
  end

  def test_find_all_handles_empty_response
    stub_request(:get, "#{@base_url}/v1/properties")
      .with(query: { 'limit' => '50', 'page' => '1' })
      .to_return(
        status: 200,
        body: { content: [], pagination: { next_page: nil } }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    properties = @repository.find_all
    assert_empty properties
  end
end
