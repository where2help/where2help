module Domain
  class Address
    attr_reader :lat, :lng
    def initialize(attrs)
      @lat = attrs[:lat]
      @lng = attrs[:lng]
    end

    def to_hash
      { "lat" => lat, "lng" => lng }
    end
  end
end
