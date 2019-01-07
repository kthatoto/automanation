class Status
  @@player_status_area_width = 40
  def initialize(win)
    @win = win
  end

  def draw
    height = @win.maxy
    @win.setpos(0, 0)
    $color.underline(@win, " " * @win.maxx)
    (1..(height - 1)).to_a.each do |y|
      @win.setpos(y, 0)
      $color.normal(@win, " " * @win.maxx)
      @win.maxx.times do |x|
        @win.setpos(y, x)
        $color.normal(@win, (x % 10).to_s)
      end
      @win.setpos(y, @@player_status_area_width)
      $color.normal(@win, '┃')
    end
  end
end
