class Maps; end

require 'clients/maps/address_mapper'

class Maps
  def client
    @client ||= Faraday.new(url: "https://maps.googleapis.com/maps/api/geocode/json") do |conn|
      conn.adapter :typhoeus
      conn.headers[:sensor] = false
      conn.request :json
      conn.response :json, :content_type => /\bjson$/
    end
  end

  def coords(opts)
    raise "opts hash requires an :address key" unless opts[:address]
    address = opts[:address]
    res = client.get(nil, address: address)
    if res.success?
      Maps::AddressMapper.map(res.body.fetch("results", []).first)
    else
      Rails.logger.debug("Coords request error: %i %s" % [res.code, res.body])
      nil
    end
  end
end
