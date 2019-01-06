require 'curses'
class Color
  @@color_ids = {
    green: 10, blue: 11, red: 12, white: 13
  }
  def color_initialize
    Curses.start_color
    Curses.use_default_colors
    Curses.init_pair(@@color_ids[:green], Curses::COLOR_BLACK, Curses::COLOR_GREEN)
    Curses.init_pair(@@color_ids[:blue], Curses::COLOR_BLACK, Curses::COLOR_BLUE)
    Curses.init_pair(@@color_ids[:red], Curses::COLOR_BLACK, Curses::COLOR_RED)
    Curses.init_pair(@@color_ids[:white], Curses::COLOR_BLACK, Curses::COLOR_WHITE)
  end
  def initialize
    color_initialize
  end
  def black(win, o)
    common(0, win, o)
  end
  def ground(win, o)
    common(1, win, o)
  end
  def green(win, o)
    common(@@color_ids[:green], win, o)
  end
  def blue(win, o)
    common(@@color_ids[:blue], win, o)
  end
  def red(win, o)
    common(@@color_ids[:red], win, o)
  end
  def white(win, o)
    common(@@color_ids[:white], win, o)
  end

  private
  def common(i, win, o)
    win.attron(Curses.color_pair(i))
    win.addstr(o)
    win.attroff(Curses.color_pair(i))
  end
end
