extends PatrolCharacter2D

const MAX_SPEED = Global.TILE * 3

onready var sprite = $Sprite

func _physics_process(_delta):
	if follow_path(MAX_SPEED):
		sprite.animation = "walk"
		sprite.flip_h = velocity.x > 0
	else:
		sprite.animation = "default"
		velocity = Vector2.ZERO
	
	$Line2D.points = path
	$Line2D.global_position = Vector2.ZERO
