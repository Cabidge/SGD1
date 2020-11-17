extends StateMachine

onready var idle_time = $IdleTime

func _ready():
	add_state("idle")
	add_state("patrol")
	add_state("attack")
	add_state("alarmed")
	# backstab
	add_state("stall")
	add_state("death")
	init_state(states.idle)

func _state_logic(delta):
	match state:
		states.idle:
			parent.lerp_vel(Vector2.ZERO, 0)
		states.patrol:
			parent.vec = parent.next_vector()
			parent.lerp_vel(parent.vec, parent.MAX_SPEED, 0.2)
			if parent.vec.x != 0:
				parent.flipped = parent.vec.x > 0
			parent.lerp_sight()
	
	parent.handle_movement()

func _transition(delta):
	match state:
		states.patrol:
			if parent.vec == Vector2.ZERO:
				return states.idle

func _enter(new, _old):
	match new:
		states.idle:
			parent.sprite.play("default")
			idle_time.start()
		states.patrol:
			parent.sprite.play("walk")
			parent.request_path()

func _exit(old, _new):
	match old:
		states.idle:
			idle_time.stop()


func _on_IdleTime_timeout():
	set_state(states.patrol)
