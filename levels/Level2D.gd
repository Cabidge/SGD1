class_name Level2D
extends Node2D

signal level_completed(next_scene)

export(PackedScene) var next_scene
export(NodePath) var elevator_path

var elevator : Node2D

func _ready():
	if elevator_path:
		elevator = get_node(elevator_path)
		var err = elevator.connect("player_entered",self,"_on_Exit_player_entered")
		assert(err == OK)

func _on_Exit_player_entered():
	yield(get_tree().create_timer(1.4),"timeout")
	emit_signal("level_completed",next_scene)
