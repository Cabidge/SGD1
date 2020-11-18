extends Area2D

signal stalled

var is_target setget set_is_target

export(NodePath) var hurtbox_path
var hurtbox : Hurtbox

export var mana_count = 1

onready var anim_player = $AnimationPlayer

func _ready():
	if hurtbox_path:
		hurtbox = get_node(hurtbox_path)

func can_stab(_player : Character2D) -> bool:
	return true

func set_is_target(new):
	is_target = new
	if is_target:
		anim_player.play("Show")
	else:
		anim_player.play_backwards("Show")

func stall():
	emit_signal("stalled")
