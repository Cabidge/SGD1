extends StateMachine

var vec : Vector2 = Vector2.ZERO
var turn_angle := 0.0

var buffered_state := 0

onready var idle_time = $IdleTime

func _ready():
	add_state("idle")
	add_state("turn")
	add_state("patrol")
	add_state("attack")
	add_state("alert")
	# backstab
	add_state("stall")
	add_state("death")
	init_state(states.idle)

func _state_logic(_delta):
	match state:
		states.attack:
			var _in_sight = parent.player_in_sight()
			parent.lerp_sight(parent.player_last_seen.angle_to_point(parent.position), 0.2)
			continue
		states.idle,states.attack,states.stall,states.death:
			parent.lerp_vel(Vector2.ZERO, 0)
		states.turn:
			parent.lerp_sight(turn_angle)
		states.patrol,states.alert:
			vec = parent.next_vector()
			parent.lerp_vel(vec, parent.MAX_SPEED, 0.1)
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
			continue
		states.patrol,states.alert:
			if vec == Vector2.ZERO:
				return states.idle
			continue
		states.idle,states.turn,states.patrol,states.alert:
			if parent.player_in_sight():
				return states.attack

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
		states.attack:
			parent.sprite.play("attack")
			wait_for_animation(states.alert)
		states.alert:
			parent.request_path(parent.alert_pos)
			continue
		states.patrol,states.alert:
			parent.sprite.play("walk")
		states.death:
			unbuffer()
			parent.sprite.play("dying")
			parent.anim_player.play("Death")

func _exit(old, new):
	match old:
		states.idle:
			idle_time.stop()
		states.attack:
			if new != states.death:
				parent.fire_orb()
				parent.alert_pos = parent.player_last_seen


func _on_IdleTime_timeout():
	set_state(states.turn)


func _on_StabRange_stalled():
	set_state(states.stall)


func _on_Guard_died():
	set_state(states.death)


func _on_Sprite_animation_finished():
	disconnect_animation()
	call_deferred("set_state",buffered_state)

func wait_for_animation(buffer : int = states.idle):
	parent.sprite.connect("animation_finished",self,"_on_Sprite_animation_finished")
	buffered_state = buffer

func disconnect_animation():
	parent.sprite.disconnect("animation_finished",self,"_on_Sprite_animation_finished")

func unbuffer():
	if parent.sprite.is_connected("animation_finished",self,"_on_Sprite_animation_finished"):
		parent.sprite.disconnect("animation_finished",self,"_on_Sprite_animation_finished")
