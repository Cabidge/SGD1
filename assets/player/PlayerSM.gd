extends StateMachine

var dir : Vector2 = Vector2.ZERO

var buffered_state : int

var stab_target

onready var mana_decay = $ManaDecay
onready var mana_regen = $ManaRegen
onready var idle_time = $IdleTime

func _ready():
	add_state("idle")
	add_state("run")
	add_state("stealth")
	add_state("parry")
	add_state("stab_stealth")
	add_state("stab")
	add_state("death")
	add_state("stall")
	init_state(states.idle)

func _state_logic(_delta):
	dir = parent.move_dir()
	
	match state:
		states.idle,states.stab_stealth,states.stab,states.death,states.stall:
			parent.lerp_vel(Vector2.ZERO, 0)
		states.run:
			parent.lerp_vel(dir, parent.MAX_SPEED)
			auto_flip()
		states.stealth,states.parry:
			parent.lerp_vel(dir, parent.SLOW_SPEED)
	parent.handle_movement()

func _unhandled_input(event):
	if event.is_action_pressed("stealth"):
		if can_stealth():
			set_state(states.stealth)
		elif state == states.stab:
			buffered_state = states.stealth
	elif event.is_action_pressed("attack"):
		if can_stab():
			var target = parent.get_stab_target()
			target.stall()
			stab_target = target
			
			set_state(states.stab_stealth)
		elif can_parry():
			set_state(states.parry)
			parent.parry()

func _transition(_delta):
	match state:
		states.idle:
			if dir != Vector2.ZERO:
				return states.run
		states.run:
			if dir == Vector2.ZERO:
				return states.idle

func _enter(new, _old):
	match new:
		states.idle:
			parent.animation = "default"
			if !parent.stealth:
				idle_time.start()
		states.run:
			if !parent.stealth:
				parent.auto_footsteps.start()
			parent.animation = "walk"
			auto_flip()
		states.stealth:
			parent.toggle_stealth()
			wait_for_animation()
			if parent.stealth:
				#Player.mana -= 1
				mana_decay.start()
				mana_regen.stop()
			else:
				mana_regen.start()
				mana_decay.stop()
		states.parry:
			wait_for_animation()
		states.stab_stealth:
			parent.flipped = stab_target.global_position.x < parent.position.x
			if parent.stealth:
				parent.camera.zoom_in(0.8)
				
				parent.toggle_stealth()
				wait_for_animation(states.stab)
				mana_decay.stop()
				mana_regen.start()
			else:
				set_state(states.stab)
		states.stab:
			parent.stab_begin(stab_target)
			wait_for_animation(states.idle)
		states.death,states.stall:
			mana_regen.stop()
			mana_decay.stop()
			unbuffer()
			continue
		states.death:
			parent.animation = "dying"

func _exit(old, _new):
	match old:
		states.idle:
			idle_time.stop()
		states.run:
			if !parent.stealth:
				parent.auto_footsteps.stop()
		states.stab:
			parent.camera.zoom_in(1)


func auto_flip():
	if dir.x != 0:
		parent.flipped = dir.x < 0


func can_stealth() -> bool:
	return [states.idle,states.run].has(state) and Player.mana > 0

func can_parry() -> bool:
	return [states.idle,states.run].has(state) and !parent.stealth and parent.parry_cooldown.is_stopped()

func can_stab() -> bool:
	return [states.idle,states.run].has(state) and parent.get_stab_target() != null


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


func _on_ManaDecay_timeout():
	Player.health += 1
	Player.mana -= 1
	if Player.mana == 0 and parent.stealth and state != states.stealth:
		set_state(states.stealth)

func _on_ManaRegen_timeout():
	if parent.combat_duration.is_stopped():
		Player.health += 2
		Player.mana += 1

func _on_IdleTime_timeout():
	parent.animation = "idle_start"


func _on_Player_died():
	set_state(states.death)


func _on_Player_stalled():
	set_state(states.stall)
