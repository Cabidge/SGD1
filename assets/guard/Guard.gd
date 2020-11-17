extends PatrolCharacter2D

const MAX_SPEED = Global.TILE * 3

var flipped = false setget set_flipped

var vec : Vector2 = Vector2.ZERO

onready var sprite = $Sprite

func _physics_process(_delta):
	# debug line
	$Line2D.points = path
	$Line2D.global_position = Vector2.ZERO

func lerp_sight():
	if vec != Vector2.ZERO:
		var a = vec.angle()
		$Light2D.rotation = lerp_angle($Light2D.rotation,a,0.2)

func set_flipped(new):
	flipped = new
	sprite.flip_h = flipped
