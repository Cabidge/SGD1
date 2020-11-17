extends PatrolCharacter2D

const MAX_SPEED = Global.TILE * 3

var flipped = false setget set_flipped
var angle := 0.0 setget set_angle, get_angle

onready var sprite = $Sprite

func _physics_process(_delta):
	# debug line
	$Line2D.points = path
	$Line2D.global_position = Vector2.ZERO

func lerp_sight(angle : float):
	$Light2D.rotation = lerp_angle($Light2D.rotation,angle,0.04)

func set_flipped(new):
	flipped = new
	sprite.flip_h = flipped

func set_angle(new):
	angle = new

func get_angle():
	return $Light2D.rotation
