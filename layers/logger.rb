class Logger
  def initialize(win)
    @win = win
    @logs = []
  end
  def draw
    height = @win.maxy - 1
    width = @win.maxx
    $color.underline(@win, 0, 0, " " * @win.maxx)
    (1..height).to_a.each do |y|
      $color.normal(@win, y, 0, "┃" + (" " * (@win.maxx - 1)))
    end
    logy = 1
    @logs.reverse.each do |log|
      $color.normal(@win, logy, 1, log.get_message)
      logy += 1
      break if logy - 1 >= height
    end
  end

  def put(log)
    raise unless Log === log
    @logs << log
  end

  def stdout(message)
    `echo '#{message}' >> .log`
  end
end
