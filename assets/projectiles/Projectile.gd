extends KinematicBody2D

signal fired(vec)
signal collided(collision)

export var speed := 1.0

var velocity := Vector2.ZERO

func fire_at(pos : Vector2):
	var vec = (pos - global_position).normalized()
	velocity = vec * speed
	emit_signal("fired",vec)

func fire_at_angle(angle : float):
	var vec = Vector2.LEFT.rotated(angle)
	velocity = vec * speed
	emit_signal("fired",vec)

func handle_collision(delta : float):
	var collision = move_and_collide(velocity * delta)
	if collision:
		emit_signal("collided",collision)
		call_deferred("free")
