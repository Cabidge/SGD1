extends Node

var initial_scene = load("res://levels/Level1.tscn")

var current_level : Level2D
var current_scene : PackedScene

var last_health := Player.MAX_HEALTH

onready var ui = $CanvasLayer/UI

onready var door_transition = $CanvasLayer/DoorTransition

onready var crt = $CanvasLayer/CRT
onready var crt_anim = crt.get_node("AnimationPlayer")
onready var crt_button_sound = crt.get_node("CRTButton")

func _ready():
#	load_scene(initial_scene)
	
	var err = Player.connect("updated_health",self,"_on_Player_updated_health")
	assert(err == OK)


#func _input(event):
#	if event.is_action_pressed("reload"):
#		change_scene(current_scene)

func load_scene(scene : PackedScene):
	if current_level != null:
		remove_child(current_level)
		current_level.free()
	
	current_level = scene.instance()
	var err = current_level.connect("level_completed",self,"_on_current_level_complete")
	assert(err == OK)
	add_child(current_level)
	
	current_scene = scene
	
	# Reset Player var
	Player.health = Player.MAX_HEALTH
	Player.mana = Player.MAX_MANA
	Player.has_id = false
	ui.reset_all()
	
	# reset crt
	crt_anim.play_backwards("MissionFailed")
	crt_anim.seek(0)

func change_scene(scene : PackedScene):
	door_transition.close()
	yield(get_tree().create_timer(0.6),"timeout")
	load_scene(scene)
	yield(get_tree().create_timer(0.6),"timeout")
	door_transition.open()

func restart_level():
	crt.material.set_shader_param("aberration_amount",3)
	yield(get_tree().create_timer(0.1),"timeout")
	door_transition.progress = 1
	yield(get_tree().create_timer(0.1),"timeout")
	load_scene(current_scene)
	yield(get_tree().create_timer(0.6),"timeout")
	door_transition.open()


func _on_current_level_complete(scene : PackedScene):
	Player.scores.append(Player.times_spotted)
	Player.times_spotted = 0
	if scene:
		change_scene(scene)
	else:
		change_scene(initial_scene)


func _on_Player_updated_health(health):
	if health < last_health: # I'm too lazy to do this correctly, but it works so it's fine
		crt_anim.play("Damaged")
		crt_anim.seek(0)
		if health <= 0:
			crt_anim.queue("MissionFailed")
	last_health = health


func _on_Retry_pressed():
	crt_anim.stop()
	
	crt_button_sound.play()
	restart_level()


func _on_Start_pressed():
	$CanvasLayer/Menu.stop()
	
	load_scene(initial_scene)
