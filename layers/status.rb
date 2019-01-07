class Status
  def initialize(win, player_status_width)
    @win = win
    @player_status_width = player_status_width
  end

  def draw(pos, player)
    height = @win.maxy - 1
    $color.underline(@win, 0, 0, " " * @win.maxx)
    (1..height).to_a.each do |y|
      $color.normal(@win, y, 0, " " * @win.maxx)
      $color.normal(@win, y, @player_status_width, '┃')
    end

    $color.normal(@win, 1, 1, "HP")
    $color.black(@win, 1, 4, " " * 15)
    $color.green(@win, 1, 4, " " * (15 * player.hp / player.max_hp).to_i)
    $color.normal(@win, 2, 4, "#{player.hp}/#{player.max_hp}")

    $color.normal(@win, height, 1, "y:#{pos[:y]},x:#{pos[:x]}")
  end
end
