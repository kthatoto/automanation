require 'curses'
class Color
  @@color_ids = {
    green: 10, blue: 11, red: 12,
  }
  def color_initialize
    Curses.start_color
    Curses.use_default_colors
    Curses.init_pair(@@color_ids[:green], Curses::COLOR_BLACK, Curses::COLOR_GREEN)
    Curses.init_pair(@@color_ids[:blue], Curses::COLOR_BLACK, Curses::COLOR_BLUE)
    Curses.init_pair(@@color_ids[:red], Curses::COLOR_BLACK, Curses::COLOR_RED)
  end
  def initialize(win)
    color_initialize
    @win = win
  end
  def black o
    common(0, o)
  end
  def ground o
    common(1, o)
  end
  def green o
    common(@@color_ids[:green], o)
  end
  def blue o
    common(@@color_ids[:blue], o)
  end
  def red o
    common(@@color_ids[:red], o)
  end

  private
  def common(i, o)
    @win.attron(Curses.color_pair(i))
    @win.addstr(o)
    @win.attroff(Curses.color_pair(i))
  end
end
