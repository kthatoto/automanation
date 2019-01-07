require 'curses'
class Color
  @@color_ids = {
    white: 10, normal: 11, green: 12, blue: 13, red: 14
  }
  def color_initialize
    Curses.start_color
    Curses.use_default_colors
    Curses.init_pair(@@color_ids[:white], Curses::COLOR_BLACK, Curses::COLOR_WHITE)
    Curses.init_pair(@@color_ids[:normal], Curses::COLOR_WHITE, Curses::COLOR_BLACK)
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
  @@color_ids.each do |color, id|
    define_method(color) do |win, o|
      common(id, win, o)
    end
  end
  def underline(win, o)
    win.attron(Curses::A_UNDERLINE)
    win.addstr(o)
    win.attroff(Curses::A_UNDERLINE)
  end

  private
  def common(i, win, o)
    win.attron(Curses.color_pair(i))
    win.addstr(o)
    win.attroff(Curses.color_pair(i))
  end
end
