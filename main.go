package main

import (
	tl "github.com/JoelOtter/termloop"
	"math/rand"
	"time"
)

type Player struct {
	*tl.Entity
	prevX int
	prevY int
	level *tl.BaseLevel
}

type Enemy struct {
	*tl.Entity
	prevX int
	prevY int
}

func (player *Player) Draw(screen *tl.Screen) {
	screenWidth, screenHeight := screen.Size()
	x, y := player.Position()
	player.level.SetOffset(screenWidth/2-x, screenHeight/2-y)
	player.Entity.Draw(screen)
}

func (enemy *Enemy) Draw(screen *tl.Screen) {
	enemy.Entity.Draw(screen)
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

func (enemy *Enemy) Tick(event tl.Event) {
	if event.Type == tl.EventKey {
		enemy.prevX, enemy.prevY = enemy.Position()
		rand.Seed(time.Now().UnixNano())
		r := rand.Int()
		switch r % 5 {
		case 0:
			enemy.SetPosition(enemy.prevX+2, enemy.prevY)
		case 1:
			enemy.SetPosition(enemy.prevX-2, enemy.prevY)
		case 2:
			enemy.SetPosition(enemy.prevX, enemy.prevY-1)
		case 3:
			enemy.SetPosition(enemy.prevX, enemy.prevY+1)
		}
	}
}

func (player *Player) Collide(collision tl.Physical) {
	if _, ok := collision.(*tl.Rectangle); ok {
		player.SetPosition(player.prevX, player.prevY)
	}
}

func (enemy *Enemy) Collide(collision tl.Physical) {
	if _, ok := collision.(*tl.Rectangle); ok {
		enemy.SetPosition(enemy.prevX, enemy.prevY)
	}
}

func generateMap(l *tl.BaseLevel) {
	l.AddEntity(tl.NewRectangle(2*-1, -1, 2*1, 8, tl.ColorBlue))
	l.AddEntity(tl.NewRectangle(2*-1, -1, 2*8, 1, tl.ColorBlue))
	l.AddEntity(tl.NewRectangle(2*7, -1, 2*1, 4, tl.ColorBlue))
	l.AddEntity(tl.NewRectangle(2*7, 4, 2*1, 3, tl.ColorBlue))
	l.AddEntity(tl.NewRectangle(2*-1, 6, 2*8, 1, tl.ColorBlue))
	l.AddEntity(tl.NewRectangle(2*7, 2, 2*7, 1, tl.ColorBlue))
	l.AddEntity(tl.NewRectangle(2*7, 4, 2*5, 1, tl.ColorBlue))
	l.AddEntity(tl.NewRectangle(2*13, 2, 2*1, 8, tl.ColorBlue))
	l.AddEntity(tl.NewRectangle(2*11, 4, 2*1, 6, tl.ColorBlue))
	l.AddEntity(tl.NewRectangle(2*8, 9, 2*3, 1, tl.ColorBlue))
	l.AddEntity(tl.NewRectangle(2*7, 9, 2*1, 8, tl.ColorBlue))
	l.AddEntity(tl.NewRectangle(2*7, 16, 2*11, 1, tl.ColorBlue))
	l.AddEntity(tl.NewRectangle(2*18, 10, 2*1, 7, tl.ColorBlue))
	l.AddEntity(tl.NewRectangle(2*13, 9, 2*6, 1, tl.ColorBlue))
}

func main() {
	g := tl.NewGame()
	level := tl.NewBaseLevel(tl.Cell{Bg: tl.ColorBlack})
	generateMap(level)

	player := Player{
		Entity: tl.NewEntity(0, 0, 2, 1),
		level:  level,
	}
	player.SetCell(0, 0, &tl.Cell{Bg: tl.ColorGreen})
	player.SetCell(1, 0, &tl.Cell{Bg: tl.ColorGreen})
	level.AddEntity(&player)
	enemies := []*Enemy{
		&Enemy{Entity: tl.NewEntity(20, 12, 2, 1)},
		&Enemy{Entity: tl.NewEntity(24, 14, 2, 1)},
		&Enemy{Entity: tl.NewEntity(30, 13, 2, 1)},
	}
	for _, enemy := range enemies {
		enemy.SetCell(0, 0, &tl.Cell{Bg: tl.ColorRed})
		enemy.SetCell(1, 0, &tl.Cell{Bg: tl.ColorRed})
		level.AddEntity(enemy)
	}

	g.Screen().SetFps(30)
	g.Screen().SetLevel(level)
	g.Start()
}
