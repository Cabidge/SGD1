class_name Level2D
extends Node2D

signal player_died
signal level_completed(next_scene)

export(PackedScene) var next_scene
export(NodePath) var player_path

var player : Character2D

func _ready():
	if player_path:
		print("a")
