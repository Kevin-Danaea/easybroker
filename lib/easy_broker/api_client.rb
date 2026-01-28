require 'httparty'

module EasyBroker
  class ApiClient
    include HTTParty

    def initialize(api_key:, base_url: 'https://api.stagingeb.com')
      @api_key = api_key
      self.class.base_uri base_url
    end

    def get(endpoint, query: {})
      response = self.class.get(endpoint, headers: headers, query: query)
      handle_response(response)
    end

    private

    def headers
      {
        'X-Authorization' => @api_key,
        'Content-Type' => 'application/json'
      }
    end

    def handle_response(response)
      if response.success?
        response.parsed_response
      else
        raise "API Error: #{response.code} - #{response.message}"
      end
    end
  end
end
