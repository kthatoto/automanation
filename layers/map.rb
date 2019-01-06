class Map
  @@mapchips_directory = "./data/maps"
  def initialize(win)
    @win = win
    @location = "town"
    get_mapchips
  end
  def draw(pos)
    height = @win.maxy
    width = @win.maxx / 2
    height.times do |y|
      width.times do |x|
        coordinate = {
          x: pos[:x] - width / 2 + x,
          y: pos[:y] - height / 2 + y,
        }
        if coordinate[:y] < 0 || coordinate[:x] < 0
          @win.setpos(y, x * 2)
          $color.black("  ")
          next
        end
        draw_by_coordinate(coordinate, y, x)
      end
    end
  end

  def draw_by_coordinate(coordinate, y, x)
    begin
      mapchip = @mapchips[coordinate[:y]][coordinate[:x]]
      @win.setpos(y, x * 2)
      case mapchip
      when 0, nil
        raise
      when 1
       $color.ground("  ")
      end
    rescue
    end
  end

  def input_key(key, **options)
    pos = options[:pos]
    prev_pos = pos.dup
    case key
    when ?j
      pos[:y] += 1
    when ?h
      pos[:x] -= 1
    when ?k
      pos[:y] -= 1
    when ?l
      pos[:x] += 1
    end
    return prev_pos unless valid_pos?(pos)
    return pos
  end

  def valid_pos?(pos)
    return false if pos[:y] < 0 || pos[:x] < 0
    mapchip = @mapchips[pos[:y]] && @mapchips[pos[:y]][pos[:x]]
    return false if [nil, 0].include?(mapchip)
    true
  end

  private
  def get_mapchips
    @mapchips = []
    File.open("#{@@mapchips_directory}/#{@location}.txt") do |file|
      file.read.split("\n").each do |line|
        @mapchips << line.split.map(&:to_i)
      end
    end
  end
end
