extends Node

var initial_scene = load("res://levels/Level1.tscn")

var current_level : Level2D
var current_scene : PackedScene

var last_health := Player.MAX_HEALTH

var level_num := 0

onready var ui = $CanvasLayer/UI

onready var door_transition = $CanvasLayer/DoorTransition

onready var crt = $CanvasLayer/CRT
onready var crt_anim = crt.get_node("AnimationPlayer")
onready var crt_button_sound = crt.get_node("CRTButton")

onready var floor_ui = $CanvasLayer/Floor

onready var main_menu = $CanvasLayer/Menu

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

func change_scene(scene : PackedScene, next_level = false):
	door_transition.close()
	yield(get_tree().create_timer(0.6),"timeout")
	load_scene(scene)
	yield(get_tree().create_timer(0.6),"timeout")
	door_transition.open()
	
	if next_level:
		show_level_ui()

func restart_level():
	crt.material.set_shader_param("aberration_amount",3)
	yield(get_tree().create_timer(0.1),"timeout")
	door_transition.progress = 1
	yield(get_tree().create_timer(0.1),"timeout")
	load_scene(current_scene)
	yield(get_tree().create_timer(0.6),"timeout")
	door_transition.open()


func end_game():
	door_transition.close()
	yield(get_tree().create_timer(0.6),"timeout")


func _on_current_level_complete(scene : PackedScene):
	Player.scores.append(Player.times_spotted)
	Player.times_spotted = 0
	if scene:
		change_scene(scene, true)
	else:
		end_game()


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
	current_scene = initial_scene
	
	crt_button_sound.play()
	restart_level()
	
	yield(get_tree().create_timer(0.8),"timeout")
	
	crt_anim.stop()
	
	main_menu.stop()
	show_level_ui()
	
	ui.visible = true

func show_level_ui():
	floor_ui.show_floor(level_num)
	level_num += 1
