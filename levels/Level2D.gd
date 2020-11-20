class_name Level2D
extends Node2D

signal level_completed(next_scene)

export(PackedScene) var next_scene
export(NodePath) var player_path

var player : Character2D

func _ready():
	assert(player_path, name + " is missing path to player")
	
	player = get_node(player_path)
