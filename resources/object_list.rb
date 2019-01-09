class ObjectList
  def initialize
    @objects = {}
  end
  def [](key)
    @objects[key]
  end
  def all_objects
    @objects.map{|_, objects| objects}.flatten
  end
  def push(key, object)
    raise unless Object === object
    @objects[key] = @objects[key].to_a << object
  end
  def clear(key)
    @objects[key] = []
  end
  def clear_all
    @objects = {}
  end
  def get_object_by_coordinate(y, x)
    all_objects.find{|object|
      object.y == y && object.x == x
    }
  end
end
