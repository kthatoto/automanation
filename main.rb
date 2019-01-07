require 'bundler/setup'
require 'curses'
['utils', 'layers'].each {|directory|
  Dir["./#{directory}/*.rb"].each {|file| require file}
}

Curses.init_screen
Curses::noecho
Curses.curs_set(0)

STATUS_AREA_HEIGHT = 10

begin
  win = Curses::Window.new(Curses.lines - STATUS_AREA_HEIGHT, Curses.cols, 0, 0)
  swin = Curses::Window.new(STATUS_AREA_HEIGHT, win.maxx, win.maxy, 0)
  win.nodelay = 1
  swin.nodelay = 1
  $color = Color.new
  map = Map.new(win, "town")
  pos = map.get_init_pos
  player = Player.new(win)
  status = Status.new(swin)
  loop do
    win.clear
    swin.clear

    map.draw(pos)
    player.draw

    status.draw
    swin.refresh

    key = win.getch
    break if key == ?q
    pos = map.input_key(key, pos: pos)
    sleep 0.03
  end
ensure
  Curses.close_screen
end
