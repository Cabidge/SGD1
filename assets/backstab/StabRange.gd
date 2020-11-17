extends Area2D

signal stalled

var is_target setget set_is_target

export(NodePath) var hurtbox_path
var hurtbox : Hurtbox

export var mana_count = 1

func _ready():
	if hurtbox_path:
		hurtbox = get_node(hurtbox_path)

func can_stab(_player : Character2D) -> bool:
	return true

func set_is_target(new):
	is_target = new

func stall():
	emit_signal("stalled")
