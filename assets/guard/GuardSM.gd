extends StateMachine

var vec : Vector2 = Vector2.ZERO
var turn_angle := 0.0

var buffered_state := 0

var respotted = false

onready var idle_time = $IdleTime

func _ready():
	add_state("idle")
	add_state("turn")
	add_state("patrol")
	add_state("attack")
	# backstab
	add_state("stall")
	add_state("death")
	init_state(states.idle)

func _state_logic(_delta):
	match state:
		states.attack:
			var _in_sight = parent.player_in_sight()
			parent.lerp_sight(parent.player_last_seen.angle_to_point(parent.position), 0.15)
			continue
		states.turn:
			parent.lerp_sight(turn_angle)
			continue
		states.idle,states.attack,states.stall,states.death,states.turn:
			parent.lerp_vel(Vector2.ZERO, 0)
		states.patrol:
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
			if abs(wrapf(turn_angle - parent.angle, -PI, PI)) <= 0.1:
				return states.patrol
			continue
		states.patrol:
			if vec == Vector2.ZERO:
				return states.idle
			continue
		states.idle,states.turn,states.patrol:
			if parent.player_in_sight():
				return states.attack

func _enter(new, _old):
	match new:
		states.idle:
			idle_time.start()
			continue
		states.turn:
			if parent.path.size() > 0:
				turn_angle = parent.next_vector().angle()
				if abs(wrapf(turn_angle - parent.angle, -PI, PI)) <= 0.2:
					set_state(states.patrol)
				else:
					continue
			else:
				parent.alert_level -= 1
				set_state(states.idle)
		states.stall,states.turn,states.idle:
			parent.sprite.play("default")
		states.attack:
			if !respotted:
				Player.times_spotted += 1
				parent.alert_audio.play(0, parent.player_last_seen)
			
			parent.charge_audio.play()
			
			parent.alert_level = 4
			parent.sprite.play("attack")
			wait_for_animation(states.turn)
		states.patrol:
			parent.sprite.play("walk")
		states.death:
			unbuffer()
			parent.sprite.play("dying")
			parent.anim_player.play("Death")

func _exit(old, new):
	match old:
		states.idle:
			idle_time.stop()
		states.patrol:
			parent.alert_level -= 1
			parent.current_alert = 0
		states.attack:
			parent.charge_audio.stop()
			if new != states.death:
				parent.fire_orb()
				if !parent.player_in_sight():
					parent.extend_player_seen()
					parent.request_path(parent.player_last_seen)
					respotted = false
				else:
					respotted = true


func _on_IdleTime_timeout():
	if parent.alert_pos != Vector2.ZERO:
		parent.request_path(parent.alert_pos)
		parent.alert_pos = Vector2.ZERO
	else:
		parent.request_path()
	set_state(states.turn)


func _on_StabRange_stalled():
	set_state(states.stall)


func _on_Guard_died():
	set_state(states.death)


func _on_Sprite_animation_finished():
	disconnect_animation()
	call_deferred("set_state",buffered_state)

func wait_for_animation(buffer : int = states.idle):
	if parent.sprite.is_connected("animation_finished",self,"_on_Sprite_animation_finished"):
		unbuffer()
	
	parent.sprite.connect("animation_finished",self,"_on_Sprite_animation_finished")
	buffered_state = buffer

func disconnect_animation():
	parent.sprite.disconnect("animation_finished",self,"_on_Sprite_animation_finished")

func unbuffer():
	if parent.sprite.is_connected("animation_finished",self,"_on_Sprite_animation_finished"):
		parent.sprite.disconnect("animation_finished",self,"_on_Sprite_animation_finished")


func _on_AlertReceiver_alerted(level, threshold, location):
	if [states.death,states.stall].has(state):
		return
	if parent.alert_level >= threshold:
		if level >= parent.current_alert:
			parent.request_path(location)
			set_state(states.turn)
			parent.alert_level = max(parent.alert_level,level)
		elif level == parent.current_alert:
			parent.alert_pos = location
