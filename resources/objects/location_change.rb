class Object::LocationChange < Object
  def initialize(location, y, x, slug)
    @location = location
    @y = y
    @x = x
    @slug = slug
    @treadable = true
  end
end
