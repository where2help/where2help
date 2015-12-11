require 'clients'
module Jobs
  class Coords
    COUNTRY="Austria"
    class << self
      def add_to(need)
        client  = Maps.new
        address = location(need)
        coords  = client.coords(address: address)
        if invalid?(coords)
          address = city_only(need)
          coords  = client.coords(address: address)
        end
        update_need!(need, coords) if coords
      end

      private

      def update_need!(need, coords)
        need.update_attributes(lat: coords.lat, lng: coords.lng)
      end

      def location(need)
        city, place = need.city, need.location
        return "%s, %s" % [place, city]
      end

      def city_only(need)
        city = need.city
        return "%s, %s" % [city, COUNTRY]
      end

      def invalid?(coords)
        coords.nil? || coords.lat.nil? || coords.lng.nil?
      end
    end
  end
end
