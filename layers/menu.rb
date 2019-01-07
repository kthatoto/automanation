class Menu
  def initialize(win)
    @win = win
    @status = :menu
  end
  def draw
    height = @win.maxy
    (height - 1).times do |y|
      $color.normal(@win, y, 0, "┃" + (" " * (@win.maxx - 1)))
    end
    $color.normal_with_underline(@win, height, 0, "┃" + (" " * (@win.maxx - 1)))
    $color.normal(@win, 0, 1, "(M)enu, (L)ist")
    case @status
    when :menu
      $color.normal(@win, 1, 1, "Menu")
    when :list
      $color.normal(@win, 1, 1, "List")
    end
  end

  def input_key(key)
    return if key.nil?
    case key
    when ?L
      @status = :list
    when ?M
      @status = :menu
    end
  end
end
