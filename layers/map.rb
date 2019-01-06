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
