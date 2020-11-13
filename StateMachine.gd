class_name StateMachine
extends Node

var states = {}
var state = null setget set_state
var previous_state = null

onready var parent = get_parent()

func _physics_process(delta):
	if state != null:
		_state_logic(delta)
		var trans = _transition(delta)
		if trans != null:
			set_state(trans)

func add_state(state_name : String):
	states[state_name] = states.size()

func _state_logic(_delta):
	pass

func _transition(_delta):
	return null

func _enter(_new_state, _last_state):
	pass

func _exit(_last_state, _new_state):
	pass

func set_state(new_state : int):
	previous_state = state
	state = new_state
	
	if previous_state != null:
		_exit(previous_state, new_state)
	_enter(new_state, previous_state)
