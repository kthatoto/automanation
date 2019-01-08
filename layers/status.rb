class Status
  def initialize(win)
    @win = win
  end

  def draw(pos:, player:)
    height = @win.maxy - 1
    $color.underline(@win, 0, 0, " " * @win.maxx)
    (1..height).to_a.each do |y|
      $color.normal(@win, y, 0, " " * @win.maxx)
    end

    # HP
    $color.normal(@win, 1, 1, "HP")
    $color.black(@win, 1, 4, " " * 15)
    $color.bg_green(@win, 1, 4, " " * (15 * player.hp / player.max_hp).to_i)
    $color.normal(@win, 2, 4, "#{player.hp}/#{player.max_hp}")

    $color.normal(@win, height, 1, "y:#{pos[:y]},x:#{pos[:x]}")
  end
end
