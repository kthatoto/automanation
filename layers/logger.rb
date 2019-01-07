class Logger
  def initialize(win, player_status_width)
    @win = win
    @player_status_width = player_status_width
    @corner_pos = { y: 1, x: @player_status_width + 1 }
    @logs = []
  end
  def draw
    height = @win.maxy - 1
    width = @win.maxx - @corner_pos[:x]
    @logs.reverse.each_with_index do |log, i|
      $color.normal(@win, @corner_pos[:y] + i, @corner_pos[:x], log)
      break if height <= i + 1
    end
  end

  def put(log)
    @logs << log
  end
end
