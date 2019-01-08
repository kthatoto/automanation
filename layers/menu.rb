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

    if @status != :respawn
      $color.send(
        @status == :menu ? 'normal_with_bold' : 'normal',
        @win, 0, 1, "(M)enu"
      )
      $color.send(
        @status == :list ? 'normal_with_bold' : 'normal',
        @win, 0, 8, "(L)ist"
      )
    end
    case @status
    when :menu
      draw_menu
    when :list
      draw_list
    when :respawn
      draw_respawn
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

  def change_status(status)
    @status = :respawn if status == :respawn
  end

  private
  def draw_menu
  end

  def draw_list
    listy = 2
    $current_object_list.all_objects.each do |o|
      line = "[y:#{o.y.to_s.rjust(3)}, x:#{o.x.to_s.rjust(3)}]"
      line << " #{o.dest}"
      $color.normal(@win, listy, 1, line)
      listy += 1
    end
  end

  def draw_respawn
    $color.normal(@win, 1, 1, "(R)espawn")
  end
end
