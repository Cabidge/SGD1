extends KinematicBody2D

const MAX_SPEED = Global.TILE * 5 # tiles per second
const SLOW_SPEED = MAX_SPEED * 0.1

var velocity : Vector2 = Vector2.ZERO

var stealth = false

var flipped = false setget set_flipped
var animation : String setget set_animation

onready var sprite = $Sprite
onready var pivot = $Pivot

func lerp_vel(dir : Vector2, speed = MAX_SPEED):
	velocity = velocity.linear_interpolate(dir * speed, 0.3)

func handle_movement():
	velocity = move_and_slide(velocity)

func move_dir() -> Vector2:
	var x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x,y).normalized()

func set_flipped(new):
	flipped = new
	sprite.flip_h = flipped

func set_animation(anim : String):
	if anim == "parry":
		sprite.offset.x = -Global.negative_bool(flipped) * 4
	else :
		sprite.offset.x = 0
	
	animation = anim
	if stealth:
		animation += "_stealth"
	
	sprite.play(animation)

func toggle_stealth():
	stealth = !stealth
	sprite.play("transition",!stealth)

func parry():
	set_flipped(get_global_mouse_position().x < position.x)
	set_animation("parry")
	pivot.swipe()
