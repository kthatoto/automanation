class Map
  @@mapchips_directory = "./data/maps"
  @@invalid_chip_types = ['0', nil, false]
  def initialize(win)
    @win = win
    @location = "town"
    load_map
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

  def get_init_pos
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

  private
  def load_map
    @mapchips = []
    map_loading = false
    File.open("#{@@mapchips_directory}/#{@location}.txt") do |file|
      file.read.split("\n").each do |line|
        (map_loading = true; next) if line == 'mapstart'
        (map_loading = false; next) if line == 'mapend'
        (@mapchips << line.split; next) if map_loading
      end
    end
  end

  def draw_by_coordinate(coordinate, y, x)
    begin
      cy = coordinate[:y]
      cx = coordinate[:x]
      mapchip = get_mapchip(cy, cx)
      raise if mapchip.nil?
      chip_type = mapchip[0]
      raise if @@invalid_chip_types.include?(chip_type)
      @win.setpos(y, x * 2)
      case chip_type
      when "1"
       $color.ground("  ")
      end
    rescue
    end
  end

  def valid_pos?(pos)
    return false if pos[:y] < 0 || pos[:x] < 0
    mapchip = get_mapchip(pos[:y], pos[:x])
    return false if mapchip.nil?
    chip_type = mapchip[0]
    return false if @@invalid_chip_types.include?(chip_type)
    true
  end

  def get_mapchip(y, x)
    @mapchips[y] && @mapchips[y][x]
  end
end
