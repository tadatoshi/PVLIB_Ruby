class Location

  attr_accessor :latitude, :longitude, :altitude

  def initialize(latitude, longitude, altitude)
    @latitude = latitude
    @longitude = longitude
    @altitude = altitude
  end

end