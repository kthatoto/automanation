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
  pos = { x: 0, y: 0 }
  $color = Color.new(win)
  map = Map.new(win)
  player = Player.new(win)
  loop do
    win.clear

    map.draw(pos)
    player.draw

    key = win.getch
    case key
    when ?q
      break
    when ?j
      pos[:y] += 1
    when ?h
      pos[:x] -= 1
    when ?k
      pos[:y] -= 1
    when ?l
      pos[:x] += 1
    end
    sleep 0.01
  end
ensure
  Curses.close_screen
end
