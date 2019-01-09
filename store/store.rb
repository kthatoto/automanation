class Store
  def initialize
    @actions = {}
  end
  def [](key)
    @actions[key].to_a
  end
  def push(key, action)
    raise unless Action === action
    @actions[key] = @actions[key].to_a << action
  end
  def clear(key)
    @actions[key] = []
  end
  def clear_all
    @actions = {}
  end
end
