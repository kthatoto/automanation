class Map
  @@mapchips_directory = "./data/maps"
  @@invalid_chip_type_values = ['0', nil, false]
  @@chip_types = {
    wall: '0',
    ground: '1',
    object: '2',
    location_change: '5',
  }

  def initialize(win, init_location)
    @win = win
    @current_location = init_location
    load_location
  end

  def draw(pos:)
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
    pos = options[:pos].dup
    player = options[:player]
    return if key.nil?
    return if !player.survived?
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
    if !valid_pos?(pos)
      player.damage(1)
      $logger.push(
        Log.new("壁にあたった！1ダメージ！残りHP:#{player.hp}"),
        100
      )
      return
    end
    if exists_object?(pos) && !exists_treadable_object?(pos)
      return
    end
    if location_changing?(pos)
      new_pos = change_location(pos)
      options[:tposes] << {pos: new_pos, priority: 60}
      return
    end
    options[:tposes] << {pos: pos, priority: 40}
  end

  def dispatch(actions, **options)
    actions.each do |action|
      case action.type
      when :respawn
        @current_location = action.location
        load_location
        new_pos = get_init_pos
        options[:tposes] << {pos: new_pos, priority: 200}
      end
    end
    $store.clear(:map)
  end

  private
  def load_location
    $current_object_list.clear(:map)
    @mapchips = []
    @locations = {}
    @init_pos_char = nil
    map_loading = false
    locations_loading = false
    characters_loading = false
    things_loading = false
    File.open("#{@@mapchips_directory}/#{@current_location}.txt") do |file|
      file.read.split("\n").each do |line|
        next if line == ''
        (map_loading = true; next) if line == 'map_start'
        (map_loading = false; next) if line == 'map_end'
        (@mapchips << line.split; next) if map_loading
        if line.start_with?('initpos')
          @init_pos_char = line.split('=')[1]
          next
        end
        (locations_loading = true; next) if line == 'locations_start'
        (locations_loading = false; next) if line == 'locations_end'
        if locations_loading
          char, slug = line.split('=')
          @locations[char.to_sym] = slug
          pos = find_pos_by_meta_char(char)
          $current_object_list.push(:map, Object::LocationChange.new(
            @current_location, pos[:y], pos[:x], slug
          ))
          next
        end
        (things_loading = true; next) if line == 'things_start'
        (things_loading = false; next) if line == 'things_end'
        if things_loading
          char, slug = line.split('=')
          pos = find_pos_by_meta_char(char)
          $current_object_list.push(:map, Object::Thing.new(
            @current_location, pos[:y], pos[:x], slug
          ))
        end
        (characters_loading = true; next) if line == 'characters_start'
        (characters_loading = false; next) if line == 'characters_end'
        if characters_loading
          char, slug = line.split('=')
          pos = find_pos_by_meta_char(char)
          $current_object_list.push(:map, Object::Character.new(
            @current_location, pos[:y], pos[:x], slug
          ))
        end
      end
    end
  end

  def change_location(pos)
    prev_location = @current_location.dup
    chip_meta = get_mapchip(pos[:y], pos[:x])[1]
    @current_location = @locations[chip_meta.to_sym]
    load_location
    @locations.each do |meta_char, location|
      if prev_location == location
        return find_pos_by_meta_char(meta_char.to_s) || { y: 0, x: 0 }
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
      chip_type_value = mapchip[0]
      raise if @@invalid_chip_type_values.include?(chip_type_value)
      case chip_type_value
      when @@chip_types[:ground]
        $color.ground(@win, y, x * 2, "  ")
      when @@chip_types[:location_change]
        $color.bg_white(@win, y, x * 2, "  ")
      when @@chip_types[:object]
        $color.bg_blue(@win, y, x * 2, "  ")
      end
    rescue
    end
  end

  def valid_pos?(pos)
    return false if pos[:y] < 0 || pos[:x] < 0
    mapchip = get_mapchip(pos[:y], pos[:x])
    return false if mapchip.nil?
    chip_type_value = mapchip[0]
    return false if @@invalid_chip_type_values.include?(chip_type_value)
    true
  end

  def exists_object?(pos)
    return false if pos[:y] < 0 || pos[:x] < 0
    mapchip = get_mapchip(pos[:y], pos[:x])
    return false if mapchip.nil?
    chip_type_value = mapchip[0]
    not_object_types = [:ground, :wall]
    return false if not_object_types.find{|type| @@chip_types[type] == chip_type_value}
    true
  end

  def exists_treadable_object?(pos)
    return false if pos[:y] < 0 || pos[:x] < 0
    object = $current_object_list.get_object_by_coordinate(pos[:y], pos[:x])
    return false if object.nil?
    object.treadable
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
