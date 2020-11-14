extends KinematicBody2D

const MAX_SPEED = Global.TILE * 5 # tiles per second
const SLOW_SPEED = MAX_SPEED * 0.1

const DEFAULT_ENERGY = 1.0
const DEFAULT_SCALE = 0.6
const STEALTH_ENERGY = 0.9
const STEALTH_SCALE = 0.4

var velocity : Vector2 = Vector2.ZERO

var stealth = false

var flipped = false setget set_flipped
var animation : String setget set_animation

var light_energy = DEFAULT_ENERGY
var light_scale = DEFAULT_SCALE

onready var sprite = $Sprite
onready var pivot = $Pivot
onready var light = $Light2D

func _physics_process(delta):
	light.energy = lerp(light.energy,light_energy, 0.1)
	light.texture_scale = lerp(light.texture_scale,light_scale, 0.1)
	
	modulate.a = lerp(modulate.a, 1.0 - 0.6 * int(stealth), 0.05)

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
	
	if stealth:
		light_energy = STEALTH_ENERGY
		light_scale = STEALTH_SCALE
	else:
		light_energy = DEFAULT_ENERGY
		light_scale = DEFAULT_SCALE
	
	Player.update_stealth(stealth)

func parry():
	set_flipped(get_global_mouse_position().x < position.x)
	set_animation("parry")
	pivot.swipe()
