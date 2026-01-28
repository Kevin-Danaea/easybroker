require_relative 'property'

module EasyBroker
  class PropertyRepository
    PROPERTIES_ENDPOINT = '/v1/properties'.freeze
    DEFAULT_LIMIT = 50

    def initialize(api_client)
      @api_client = api_client
    end

    def find_all
      all_properties = []
      page = 1

      loop do
        response = fetch_page(page)
        properties_data = response['content'] || []
        
        all_properties.concat(properties_data.map { |data| Property.new(data) })

        break unless response.dig('pagination', 'next_page')
        page += 1
      end

      all_properties
    end

    private

    def fetch_page(page)
      @api_client.get(PROPERTIES_ENDPOINT, query: { page: page, limit: DEFAULT_LIMIT })
    end
  end
end
