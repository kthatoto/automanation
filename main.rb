require 'bundler/setup'
require 'curses'
['utils', 'layers'].each {|directory|
  Dir["./#{directory}/*.rb"].each {|file| require file}
}

Curses.init_screen
Curses::noecho
Curses.curs_set(0)

begin
  win = Curses::Window.new(Curses.lines, Curses.cols, 0, 0)
  win.nodelay = 1
  $color = Color.new(win)
  map = Map.new(win, "town")
  player = Player.new(win)
  pos = map.get_init_pos
  loop do
    win.clear

    map.draw(pos)
    player.draw

    key = win.getch
    break if key == ?q
    pos = map.input_key(key, pos: pos)
    sleep 0.03
  end
ensure
  Curses.close_screen
end
