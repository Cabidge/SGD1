class_name Character2D
extends KinematicBody2D

var velocity : Vector2 = Vector2.ZERO

func lerp_vel(dir : Vector2, speed : float, weight : float = 0.3):
	velocity = velocity.linear_interpolate(dir * speed, weight)

func handle_movement():
	velocity = move_and_slide(velocity)
