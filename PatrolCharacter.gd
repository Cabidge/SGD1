class_name PatrolCharacter2D
extends Character2D

signal path_completed

var path : PoolVector2Array

func _ready():
	add_to_group("Patrol")
