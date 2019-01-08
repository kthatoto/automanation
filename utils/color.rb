require 'curses'
class Color
  include Curses
  @@color_ids = {
    bg_white: 10, bg_green: 11, bg_blue: 12, bg_red: 13,
    normal: 20,
  }
  def color_initialize
    start_color
    use_default_colors
    init_pair(@@color_ids[:bg_white], COLOR_BLACK, COLOR_WHITE)
    init_pair(@@color_ids[:bg_green], COLOR_BLACK, COLOR_GREEN)
    init_pair(@@color_ids[:bg_blue], COLOR_BLACK, COLOR_BLUE)
    init_pair(@@color_ids[:bg_red], COLOR_BLACK, COLOR_RED)
    init_pair(@@color_ids[:normal], COLOR_WHITE, COLOR_BLACK)
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
  def normal_with_underline(win, y, x, o)
    win.attron(Curses::A_UNDERLINE)
    common(@@color_ids[:normal], win, y, x, o)
    win.attroff(Curses::A_UNDERLINE)
  end
  def normal_with_bold(win, y, x, o)
    win.attron(Curses::A_BOLD)
    common(@@color_ids[:normal], win, y, x, o)
    win.attroff(Curses::A_BOLD)
  end

  private
  def common(i, win, y, x, o)
    win.setpos(y, x)
    win.attron(Curses.color_pair(i))
    win.addstr(o)
    win.attroff(Curses.color_pair(i))
  end
end
