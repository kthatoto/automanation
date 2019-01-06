class Map
  @@mapchips_directory = "./data/maps"
  @@invalid_chip_type_values = ['0', nil, false]
  @@chip_types = {
    wall: '0',
    ground: '1',
    location_change: '5',
  }

  def initialize(win, init_location)
    @win = win
    @location = init_location
    load_location
  end

  def draw(pos)
    height = @win.maxy
    width = @win.maxx / 2
    height.times do |y|
      width.times do |x|
        coordinate = {
          y: pos[:y] - height / 2 + y,
          x: pos[:x] - width / 2 + x,
        }
        next if coordinate[:y] < 0 || coordinate[:x] < 0
        draw_by_coordinate(coordinate, y, x)
      end
    end
  end

  def get_init_pos
    find_pos_by_meta_char(@init_pos_char) || { y: 0, x: 0 }
  end

  def input_key(key, **options)
    pos = options[:pos]
    return pos if key.nil?
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
    pos = change_location(pos) if location_changing?(pos)
    pos
  end

  private
  def load_location
    @mapchips = []
    @locations = {}
    @init_pos_char = nil
    map_loading = false
    locations_loading = false
    File.open("#{@@mapchips_directory}/#{@location}.txt") do |file|
      file.read.split("\n").each do |line|
        (map_loading = true; next) if line == 'mapstart'
        (map_loading = false; next) if line == 'mapend'
        (@mapchips << line.split; next) if map_loading
        if line.start_with?('initpos')
          @init_pos_char = line.split('=')[1]
          next
        end
        (locations_loading = true; next) if line == 'locationsstart'
        (locations_loading = false; next) if line == 'locationsend'
        if locations_loading
          location = line.split('=')
          @locations[location[0].to_sym] = location[1]
          next
        end
      end
    end
  end

  def change_location(pos)
    prev_location = @location.dup
    chip_meta = get_mapchip(pos[:y], pos[:x])[1]
    @location = @locations[chip_meta.to_sym]
    load_location
    @locations.each do |meta_char, location|
      if prev_location == location
        pos = find_pos_by_meta_char(meta_char.to_s) || { y: 0, x: 0 }
        break
      end
    end
    pos
  end

  def draw_by_coordinate(coordinate, y, x)
    begin
      cy = coordinate[:y]
      cx = coordinate[:x]
      mapchip = get_mapchip(cy, cx)
      raise if mapchip.nil?
      chip_type = mapchip[0]
      raise if @@invalid_chip_type_values.include?(chip_type)
      @win.setpos(y, x * 2)
      case chip_type
      when @@chip_types[:ground]
        $color.ground(@win, "  ")
      when @@chip_types[:location_change]
        $color.white(@win, "  ")
      end
    rescue
    end
  end

  def valid_pos?(pos)
    return false if pos[:y] < 0 || pos[:x] < 0
    mapchip = get_mapchip(pos[:y], pos[:x])
    return false if mapchip.nil?
    chip_type = mapchip[0]
    return false if @@invalid_chip_type_values.include?(chip_type)
    true
  end

  def location_changing?(pos)
    mapchip = get_mapchip(pos[:y], pos[:x])
    return false if mapchip.nil?
    mapchip[0] == @@chip_types[:location_change]
  end

  def get_mapchip(y, x)
    @mapchips[y] && @mapchips[y][x]
  end

  def find_pos_by_meta_char(meta_char)
    pos = nil
    catch :find_pos do
      @mapchips.each_with_index do |mapchip_row, y|
        mapchip_row.each_with_index do |mapchip, x|
          if meta_char == mapchip[1]
            pos = { y: y, x: x }
            throw :find_pos
          end
        end
      end
    end
    pos
  end
end
