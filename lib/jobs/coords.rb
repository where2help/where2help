require 'clients'
module Jobs
  class Coords
    class << self
      def add_to(need)
        client  = Maps.new
        address = location(need)
        coords  = client.coords(address: address)
        update_need!(need, coords) if coords
      end

      def update_need!(need, coords)
        need.update_attributes(lat: coords.lat, lng: coords.lng)
      end

      def location(need)
        city, place = need.city, need.location
        return "%s, %s" % [place, city]
      end
    end
  end
end
