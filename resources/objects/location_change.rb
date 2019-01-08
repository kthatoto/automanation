class LocationChange < Object
  attr_reader :dest
  def initialize(location, y, x, dest)
    @location = location
    @y = y
    @x = x
    @dest = dest
  end
end
