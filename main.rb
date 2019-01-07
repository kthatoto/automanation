require 'bundler/setup'
require 'curses'
['utils', 'layers', 'resources'].each {|directory|
  Dir["./#{directory}/*.rb"].each {|file| require file}
}

Curses.init_screen
Curses::noecho
Curses.curs_set(0)

BOTTOM_WIDOW_HEIGHT = 10
PLAYER_STATUS_WIDTH = 41
RIGHT_WINDOW_WIDTH = 30

begin
  win = Curses::Window.new(
    Curses.lines - BOTTOM_WIDOW_HEIGHT, Curses.cols - RIGHT_WINDOW_WIDTH,
    0, 0
  )
  swin = Curses::Window.new(
    BOTTOM_WIDOW_HEIGHT, PLAYER_STATUS_WIDTH,
    win.maxy, 0
  )
  logwin = Curses::Window.new(
    BOTTOM_WIDOW_HEIGHT, Curses.cols - PLAYER_STATUS_WIDTH,
    win.maxy, PLAYER_STATUS_WIDTH
  )
  rightwin = Curses::Window.new(
    win.maxy + 1, RIGHT_WINDOW_WIDTH,
    0, win.maxx
  )
  wins = [win, swin, logwin, rightwin]
  win.nodelay = 1

  $color = Color.new
  map = Map.new(win, "town")
  pos = map.get_init_pos
  player = Player.new(win)
  status = Status.new(swin)
  $logger = Logger.new(logwin)
  menu = Menu.new(rightwin)
  loop do
    wins.map(&:clear)

    map.draw(pos)
    player.draw
    status.draw(pos, player)
    $logger.draw
    menu.draw

    wins.map(&:refresh)

    key = win.getch
    break if key == ?q
    pos = map.input_key(key, pos: pos, player: player)
    menu.input_key(key)
    player.turn_direction(key)
    sleep 0.05
  end
ensure
  Curses.close_screen
end
