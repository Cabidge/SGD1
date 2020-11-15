class_name Character2D
extends KinematicBody2D

var velocity : Vector2 = Vector2.ZERO

func lerp_vel(dir : Vector2, speed : float):
	velocity = velocity.linear_interpolate(dir * speed, 0.3)

func handle_movement():
	velocity = move_and_slide(velocity)
