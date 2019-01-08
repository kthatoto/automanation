class ObjectList
  def initialize
    @objects = {}
  end
  def [](key)
    @objects[key.to_sym]
  end
  def all_objects
    @objects.map{|_, objects| objects}.flatten
  end
  def push(key, object)
    raise unless Object === object
    @objects[key.to_sym] = [] if @objects[key.to_sym].nil?
    @objects[key.to_sym] << object
  end
  def clear(key)
    @objects[key.to_sym] = []
  end
  def clear_all
    @objects = {}
  end
end
