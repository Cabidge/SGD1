extends KinematicBody2D

signal damaged(health)

const MAX_SPEED = Global.TILE * 5 # tiles per second
const SLOW_SPEED = MAX_SPEED * 0.1

var velocity : Vector2 = Vector2.ZERO

var stealth = false

var flipped = false setget set_flipped
var animation : String setget set_animation

onready var sprite = $Sprite
onready var pivot = $Pivot
onready var light = $Light2D

onready var camera = $Camera2D

onready var transition_player = $TransitionPlayer

func lerp_vel(dir : Vector2, speed = MAX_SPEED):
	velocity = velocity.linear_interpolate(dir * speed, 0.3)

func handle_movement():
	velocity = move_and_slide(velocity)
	camera.align()

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
	
	if stealth:
		transition_player.play("Transition")
	else:
		transition_player.play_backwards("Transition")
	
	Player.update_stealth(stealth)

func parry():
	set_flipped(get_global_mouse_position().x < position.x)
	set_animation("parry")
	pivot.swipe()

func damage(amount : int = 1):
	if amount <= 0:
		return
	
	emit_signal("damaged",Player.health)
	Player.health -= amount


func _on_Body_hit(info):
	damage(info.damage)
	sprite.modulate = Color.white * 20

func _on_Body_recovered():
	sprite.modulate = Color.white
