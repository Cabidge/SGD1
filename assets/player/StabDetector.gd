extends Area2D

var target = null setget set_target

onready var parent = get_parent()

func _physics_process(_delta):
	set_target(get_closest())

func set_target(new):
	if target != new:
		if target != null:
			target.is_target = false
		elif new != null:
			new.is_target = true
		
		target = new


func get_closest():
	var closest
	var dist = INF
	for in_range in get_overlapping_areas():
		if in_range.can_stab(parent) and \
				global_position.distance_squared_to(in_range.global_position) < dist:
			closest = in_range
	return closest
