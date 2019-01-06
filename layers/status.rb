class Status
  def initialize(win)
    @win = win
  end

  def draw
    height = @win.maxy
    $color.underline(@win, " " * @win.maxx)
  end
end
