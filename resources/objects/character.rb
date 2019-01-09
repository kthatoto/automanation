class Object::Character < Object
  def initialize(location, y, x, slug)
    @location = location
    @y = y
    @x = x
    @slug = slug
    @treadable = false
  end
end
