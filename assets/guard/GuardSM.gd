extends StateMachine

var vec : Vector2 = Vector2.ZERO
var turn_angle := 0.0

onready var idle_time = $IdleTime

func _ready():
	add_state("idle")
	add_state("turn")
	add_state("patrol")
	add_state("attack")
	add_state("alarmed")
	# backstab
	add_state("stall")
	add_state("death")
	init_state(states.idle)

func _state_logic(_delta):
	match state:
		states.idle,states.stall:
			parent.lerp_vel(Vector2.ZERO, 0)
		states.turn:
			parent.lerp_sight(turn_angle)
		states.patrol:
			vec = parent.next_vector()
			parent.lerp_vel(vec, parent.MAX_SPEED, 0.2)
			if vec.x != 0:
				parent.flipped = vec.x > 0
			if vec != Vector2.ZERO:
				parent.lerp_sight(vec.angle())
	
	parent.handle_movement()

func _transition(_delta):
	match state:
		states.turn:
			if abs(turn_angle - wrapf(parent.angle, -PI, PI)) <= 0.1:
				return states.patrol
		states.patrol:
			if vec == Vector2.ZERO:
				return states.idle

func _enter(new, _old):
	match new:
		states.idle:
			idle_time.start()
			continue
		states.stall,states.idle:
			parent.sprite.play("default")
		states.turn:
			parent.request_path()
			turn_angle = parent.next_vector().angle()
		states.patrol:
			parent.sprite.play("walk")
		states.death:
			parent.sprite.play("dying")
			parent.anim_player.play("Death")

func _exit(old, _new):
	match old:
		states.idle:
			idle_time.stop()


func _on_IdleTime_timeout():
	set_state(states.turn)


func _on_StabRange_stalled():
	set_state(states.stall)


func _on_Guard_died():
	set_state(states.death)
