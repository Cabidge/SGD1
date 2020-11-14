extends Sprite

var turn_frame := 0
var fire := false

var angle := 0.0 setget set_angle

func set_angle(new):
	angle = new
	
	var beta = fposmod(angle + PI/2, 2 * PI) - PI
	var x = int(round(abs(beta) / (PI / 4.0)))
	turn_frame = 4 - x
	flip_h = beta < 0 and turn_frame != 0 and turn_frame != 4
	update_frame()

func update_frame():
	frame = turn_frame * 2 + int(fire)
