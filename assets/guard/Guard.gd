extends PatrolCharacter2D

const MAX_SPEED = Global.TILE * 2.5

onready var sprite = $Sprite

func _physics_process(delta):
	if follow_path(MAX_SPEED):
		sprite.animation = "walk"
		sprite.flip_h = velocity.x > 0
	else:
		sprite.animation = "default"
