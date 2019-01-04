package main

import (
	tl "github.com/JoelOtter/termloop"
)

type Player struct {
	*tl.Entity
	prevX int
	prevY int
	level *tl.BaseLevel
	body  *tl.Rectangle
}

func (player *Player) Draw(screen *tl.Screen) {
	screenWidth, screenHeight := screen.Size()
	x, y := player.Position()
	player.level.SetOffset(screenWidth/2-x, screenHeight/2-y)
	player.Entity.Draw(screen)
}

func (player *Player) Tick(event tl.Event) {
	if event.Type == tl.EventKey {
		player.prevX, player.prevY = player.Position()
		switch event.Key {
		case tl.KeyArrowRight:
			player.SetPosition(player.prevX+2, player.prevY)
		case tl.KeyArrowLeft:
			player.SetPosition(player.prevX-2, player.prevY)
		case tl.KeyArrowUp:
			player.SetPosition(player.prevX, player.prevY-1)
		case tl.KeyArrowDown:
			player.SetPosition(player.prevX, player.prevY+1)
		}
	}
}

func (player *Player) Collide(collision tl.Physical) {
	if _, ok := collision.(*tl.Rectangle); ok {
		player.SetPosition(player.prevX, player.prevY)
	}
}

func generateMap(l *tl.BaseLevel) {
	l.AddEntity(tl.NewRectangle(14, -8, 2, 16, tl.ColorBlue))
	l.AddEntity(tl.NewRectangle(-14, -8, 2, 16, tl.ColorBlue))
	l.AddEntity(tl.NewRectangle(-14, -8, 28, 1, tl.ColorBlue))
	l.AddEntity(tl.NewRectangle(-14, 8, 30, 1, tl.ColorBlue))
}

func main() {
	g := tl.NewGame()
	level := tl.NewBaseLevel(tl.Cell{Bg: tl.ColorBlack})
	generateMap(level)

	player := Player{
		Entity: tl.NewEntity(0, 0, 2, 1),
		level:  level,
	}
	player.SetCell(0, 0, &tl.Cell{Bg: tl.ColorRed})
	player.SetCell(1, 0, &tl.Cell{Bg: tl.ColorRed})
	level.AddEntity(&player)

	g.Screen().SetFps(30)
	// g.Screen().EnablePixelMode()
	g.Screen().SetLevel(level)
	g.Start()
}
