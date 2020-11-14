extends StateMachine

onready var sight = parent.get_node("Sight") as Area2D

func _ready():
	add_state("scan")
	add_state("alert")
	call_deferred("set_state", states.scan)

func _state_logic(delta):
	match state:
		states.alert:
			pass

func _transition(delta):
	match state:
		states.scan:
			if sight.get_overlapping_bodies().size() > 0:
				return states.alert
		states.alert:
			if sight.get_overlapping_bodies().size() == 0:
				return states.scan

func _enter(new, _old):
	match new:
		states.scan:
			parent.scan_auto()

func _exit(old, _new):
	match old:
		states.scan:
			parent.scan_stop()
