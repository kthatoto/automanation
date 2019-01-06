require 'curses'
class Color
  @@color_ids = {
    white: 10, green: 11, blue: 12, red: 13
  }
  def color_initialize
    Curses.start_color
    Curses.use_default_colors
    Curses.init_pair(@@color_ids[:white], Curses::COLOR_BLACK, Curses::COLOR_WHITE)
    Curses.init_pair(@@color_ids[:green], Curses::COLOR_BLACK, Curses::COLOR_GREEN)
    Curses.init_pair(@@color_ids[:blue], Curses::COLOR_BLACK, Curses::COLOR_BLUE)
    Curses.init_pair(@@color_ids[:red], Curses::COLOR_BLACK, Curses::COLOR_RED)
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
  def white(win, o)
    common(@@color_ids[:white], win, o)
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
  def underline(win, o)
    win.attron(Curses::A_UNDERLINE)
    win.addstr(o)
    win.attroff(Curses::A_STANDOUT)
  end

  private
  def common(i, win, o)
    win.attron(Curses.color_pair(i))
    win.addstr(o)
    win.attroff(Curses.color_pair(i))
  end
end
