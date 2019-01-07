require 'bundler/setup'
require 'curses'
['utils', 'layers'].each {|directory|
  Dir["./#{directory}/*.rb"].each {|file| require file}
}

Curses.init_screen
Curses::noecho
Curses.curs_set(0)

STATUS_HEIGHT = 10
PLAYER_STATUS_WIDTH = 40

begin
  win = Curses::Window.new(Curses.lines - STATUS_HEIGHT, Curses.cols, 0, 0)
  swin = Curses::Window.new(STATUS_HEIGHT, win.maxx, win.maxy, 0)
  win.nodelay = 1
  swin.nodelay = 1
  $color = Color.new
  map = Map.new(win, "town")
  pos = map.get_init_pos
  player = Player.new(win)
  status = Status.new(swin, PLAYER_STATUS_WIDTH)
  $logger = Logger.new(swin, PLAYER_STATUS_WIDTH)
  loop do
    win.clear
    swin.clear

    map.draw(pos)
    player.draw

    status.draw(pos, player)
    $logger.draw
    swin.refresh

    key = win.getch
    break if key == ?q
    pos = map.input_key(key, pos: pos, player: player)
    sleep 0.03
  end
ensure
  Curses.close_screen
end
