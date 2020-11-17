extends PatrolCharacter2D

signal died

const MAX_SPEED = Global.TILE * 3

var flipped = false setget set_flipped
var angle := 0.0 setget set_angle, get_angle

var health := 10

onready var sprite = $Sprite
onready var anim_player = $AnimationPlayer

func _physics_process(_delta):
	# debug line
	$Line2D.points = path
	$Line2D.global_position = Vector2.ZERO

func lerp_sight(to_angle : float):
	$Light2D.rotation = lerp_angle($Light2D.rotation,to_angle,0.04)

func set_flipped(new):
	flipped = new
	sprite.flip_h = flipped

func set_angle(new):
	angle = new

func get_angle():
	return $Light2D.rotation


func damage(amount : int = 1):
	if amount <= 0:
		return
	
	health -= amount
	if health <= 0:
		emit_signal("died")

func _on_Hurtbox_hit(info):
	damage(info.damage)
	sprite.modulate = Color.white * 20

func _on_Hurtbox_recovered():
	sprite.modulate = Color.white
