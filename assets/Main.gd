extends Node

var initial_scene = load("res://levels/Level1.tscn")

var current_level : Level2D
var current_scene : PackedScene

onready var ui = $CanvasLayer/UI

onready var door_transition = $CanvasLayer/DoorTransition

func _ready():
	load_scene(initial_scene)


func _input(event):
	if event.is_action_pressed("reload"):
		restart_level()

func load_scene(scene : PackedScene):
	if current_level != null:
		remove_child(current_level)
	
	current_level = scene.instance()
	var err = current_level.connect("level_completed",self,"_on_current_level_complete")
	assert(err == OK)
	add_child(current_level)
	
	current_scene = scene
	
	# Reset Player var
	Player.health = Player.MAX_HEALTH
	Player.mana = Player.MAX_MANA
	ui.reset_all()

func change_scene(scene : PackedScene):
	door_transition.close()
	yield(get_tree().create_timer(0.6),"timeout")
	load_scene(scene)
	yield(get_tree().create_timer(0.6),"timeout")
	door_transition.open()

func restart_level():
	change_scene(current_scene)


func _on_current_level_complete(scene : PackedScene):
	if scene:
		change_scene(scene)
	else:
		change_scene(initial_scene)
