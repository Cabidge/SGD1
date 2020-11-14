extends "res://assets/projectiles/Projectile.gd"

onready var light = $Light2D

func _physics_process(delta):
	handle_collision(delta)
	
	light.energy = lerp(light.energy, 0.4, 0.2)

func _on_Timer_timeout():
	call_deferred("free")
