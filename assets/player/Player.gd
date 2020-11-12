extends KinematicBody2D

const MAX_SPEED = Global.TILE * 5 # tiles per second

var velocity : Vector2 = Vector2.ZERO

func _physics_process(_delta):
	velocity = velocity.linear_interpolate(move_dir() * MAX_SPEED, 0.2)
	velocity = move_and_slide(velocity)

func move_dir() -> Vector2:
	var x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x,y).normalized()
