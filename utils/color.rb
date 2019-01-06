require 'curses'

def color_initialize
  Curses.start_color
  Curses.use_default_colors
  Curses.init_pair(0, Curses::COLOR_BLACK, Curses::COLOR_BLACK)
  Curses.init_pair(1, Curses::COLOR_BLACK, Curses::COLOR_BLUE)
  Curses.init_pair(2, Curses::COLOR_BLACK, Curses::COLOR_RED)
  Curses.init_pair(3, Curses::COLOR_BLACK, Curses::COLOR_GREEN)
end

class Color
  def initialize(win)
    color_initialize
    @win = win
  end
  def black o
    common(0, o)
  end
  def blue o
    common(1, o)
  end
  def red o
    common(2, o)
  end
  def green o
    common(3, o)
  end

  private
  def common(i, o)
    @win.attron(Curses.color_pair(i))
    @win.addstr(o)
    @win.attroff(Curses.color_pair(i))
  end
end
