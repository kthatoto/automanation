class Player
  attr_reader :hp, :max_hp
  def initialize(win)
    @win = win
    @height = @win.maxy
    @width = @win.maxx / 2
    @max_hp = 10
    @hp = @max_hp
  end
  def draw
    height = @win.maxy
    width = @win.maxx / 2
    $color.green(@win, height / 2, width - width % 2, "  ")
  end

  def damage(amount)
    @hp = [@hp - amount, 0].max
    if @hp == 0
      $logger.put("死にました...")
    end
  end
end
