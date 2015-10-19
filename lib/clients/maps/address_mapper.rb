require 'clients/domain/address'

class Maps::AddressMapper
  def self.map(address)
    return nil if address.nil?
    lat, lng = coords(address)
    Domain::Address.new(lat: lat, lng: lng)
  end

  def self.coords(address)
    loc = address.fetch("geometry", {})
      .fetch("location", {})
    return [nil, nil] if loc.empty?
    return [loc["lat"], loc["lng"]]
  end
end
