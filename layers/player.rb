class Player
  def initialize(win)
    @win = win
    @height = @win.maxy
    @width = @win.maxx / 2
  end
  def draw
    height = @win.maxy
    width = @win.maxx / 2
    @win.setpos(height / 2, width - width % 2)
    $color.green(@win, "  ")
  end
end
