class Action
  attr_reader :type, :location
  def initialize(type, **options)
    @type = type
    @location = options[:location]
  end
end
