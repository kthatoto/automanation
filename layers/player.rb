class Player
  attr_reader :hp, :max_hp
  def initialize(win)
    @win = win
    @height = @win.maxy
    @width = @win.maxx / 2
    @direction = { code: :none, char: "  " }
    @max_hp = 10
    @hp = @max_hp
  end
  def draw
    height = @win.maxy
    width = @win.maxx / 2
    $color.bg_green(@win, height / 2, width - width % 2, @direction[:char])
  end

  def damage(amount)
    @hp = [@hp - amount, 0].max
    if @hp == 0
      $logger.put(Log.new("死にました..."))
    end
  end

  def turn_direction(key)
    case key
    when ?j
      @direction = { code: :down, char: 'Ｖ' }
    when ?h
      @direction = { code: :left, char: '＜' }
    when ?l
      @direction = { code: :right, char: '＞' }
    when ?k
      @direction = { code: :up, char: 'Ａ' }
    end
  end
end
