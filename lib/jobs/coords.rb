require 'clients'
class Jobs::Coords
  def add_to(need)
    client  = Maps.new
    address = location(need)
    coords  = client.coords(address: address)
    update_need!(need) if coords
  end

  def update_need!(need)
    need.update_attributes(lat: coords.lat, lng: coords.lng)
  end

  def location(need)
    city, place = need.city, need.location
    return "%s, %s" % [city, place]
  end
end
