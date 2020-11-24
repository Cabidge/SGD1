extends Area2D

var enabled = true setget set_enabled

onready var sprite = $Sprite
onready var light = $Light2D

onready var raycast = $RayCast2D

onready var timer = $Timer

onready var zap = $Zap

func set_enabled(new : bool):
	enabled = new
	sprite.frame = int(enabled)
	light.enabled = enabled
	set_physics_process(enabled)


func _physics_process(_delta):
	if timer.is_stopped() and Player.mana > 0:
		if player_in_sight():
			timer.start()
			Player.mana -= 1
			zap.play()

func player_in_sight() -> bool:
	var bodies = get_overlapping_bodies()
	if bodies.size() == 0:
		return false
	
	var player = bodies[0]
	raycast.cast_to = player.global_position - raycast.global_position
	raycast.force_raycast_update()
	
	return raycast.get_collider() == player
