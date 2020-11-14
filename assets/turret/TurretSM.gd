extends StateMachine

func _ready():
	add_state("scan")
	add_state("alert")
	call_deferred("set_state", states.scan)

func _state_logic(delta):
	pass

func _enter(new, _old):
	match new:
		states.idle:
			parent.scan_auto()

func _exit(old, _new):
	match old:
		states.idle:
			parent.scan_stop()
