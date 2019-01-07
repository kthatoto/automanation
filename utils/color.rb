require 'curses'
class Color
  @@color_ids = {
    white: 10, green: 11, blue: 12, red: 13,
    normal: 20, strong: 21,
  }
  def color_initialize
    Curses.start_color
    Curses.use_default_colors
    Curses.init_pair(@@color_ids[:white], Curses::COLOR_BLACK, Curses::COLOR_WHITE)
    Curses.init_pair(@@color_ids[:green], Curses::COLOR_BLACK, Curses::COLOR_GREEN)
    Curses.init_pair(@@color_ids[:blue], Curses::COLOR_BLACK, Curses::COLOR_BLUE)
    Curses.init_pair(@@color_ids[:red], Curses::COLOR_BLACK, Curses::COLOR_RED)
    Curses.init_pair(@@color_ids[:normal], Curses::COLOR_WHITE, Curses::COLOR_BLACK)
    Curses.init_pair(@@color_ids[:strong], Curses::COLOR_RED, Curses::COLOR_BLACK)
  end
  def initialize
    color_initialize
  end
  def black(win, y, x, o)
    common(0, win, y, x, o)
  end
  def ground(win, y, x, o)
    common(1, win, y, x, o)
  end
  @@color_ids.each do |color, id|
    define_method(color) do |win, y, x, o|
      common(id, win, y, x, o)
    end
  end
  def underline(win, y, x, o)
    win.attron(Curses::A_UNDERLINE)
    win.addstr(o)
    win.attroff(Curses::A_UNDERLINE)
  end

  private
  def common(i, win, y, x, o)
    win.setpos(y, x)
    win.attron(Curses.color_pair(i))
    win.addstr(o)
    win.attroff(Curses.color_pair(i))
  end
end
