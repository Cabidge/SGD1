extends Node

var initial_scene = load("res://levels/DebugLevel.tscn")

var current_level : Level2D
var current_scene : PackedScene

func _ready():
	load_scene(initial_scene)


func _input(event):
	if event.is_action_pressed("reload"):
		get_tree().reload_current_scene()


func load_scene(scene : PackedScene):
	if current_level != null:
		remove_child(current_level)
	
	current_level = scene.instance()
	add_child(current_level)
	
	current_scene = scene
	
	# Reset Player var
	Player.health = Player.MAX_HEALTH
	Player.mana = Player.MAX_MANA
