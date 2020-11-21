extends Node2D

var player_scene = load("res://assets/player/Player.tscn")

onready var elevator = $Elevator
onready var spawn_position = $SpawnPosition

func spawn_player():
	var player = player_scene.instance()
	player.position = spawn_position.global_position
	get_parent().add_child(player)
	
	elevator.player_visible = false
	elevator.enable_camera = false
