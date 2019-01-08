require 'bundler/setup'
require 'curses'
['utils', 'layers', 'resources', 'resources/objects'].each {|directory|
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

  $current_object_list = ObjectList.new
  $color = Color.new
  map = Map.new(win, "town")
  pos = map.get_init_pos
  player = Player.new(win)
  status = Status.new(swin)
  menu = Menu.new(rightwin)
  $logger = Logger.new(logwin)

  loop do
    wins.map(&:clear)
    map.draw(pos: pos)
    player.draw
    status.draw(pos: pos, player: player)
    menu.draw
    $logger.draw
    wins.map(&:refresh)

    key = win.getch
    break if key == ?q
    if !key.nil?
      pos.freeze
      tposes = []
      player.input_key(key, tposes: tposes, pos: pos)
      map.input_key(key, tposes: tposes, pos: pos, player: player)
      menu.input_key(key)
      new_pos = tposes.max_by{|tpos| tpos[:priority]}
      pos = new_pos[:pos] if !new_pos.nil?
    end

    $logger.put
    sleep 0.05
  end
ensure
  Curses.close_screen
end
