class_name InteractArea2D
extends Area2D

signal interacted

var disabled = false setget set_disabled
var selected = false setget set_selected

var indicator_scene = load("res://assets/Indicator.tscn")
var indicator

func _ready():
	indicator = indicator_scene.instance()
	add_child(indicator)
	
	collision_layer = 0
	collision_mask = 0
	set_collision_mask_bit(15,true)


func _physics_process(_delta):
	set_selected(is_in_range())


func _unhandled_input(event):
	if event.is_action_pressed("interact") and selected:
		emit_signal("interacted")


func is_in_range() -> bool:
	var bodies = get_overlapping_bodies()
	return bodies.size() > 0 and !bodies[0].stealth


func set_disabled(new):
	disabled = new
	set_physics_process(!disabled)
	if disabled:
		set_selected(false)

func set_selected(new):
	selected = new
	indicator.enabled = selected
