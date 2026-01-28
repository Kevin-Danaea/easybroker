module EasyBroker
  class Property
    attr_reader :title, :public_id, :location

    def initialize(attributes = {})
      @title = attributes['title']
      @public_id = attributes['public_id']
      @location = attributes['location']
    end
  end
end
