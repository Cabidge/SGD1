extends StateMachine

var dir : Vector2 = Vector2.ZERO

onready var mana_decay = $ManaDecay
onready var mana_regen = $ManaRegen
onready var idle_time = $IdleTime

func _ready():
	add_state("idle")
	add_state("run")
	add_state("stealth")
	add_state("parry")
	call_deferred("set_state",states.idle)

func _state_logic(_delta):
	dir = parent.move_dir()
	
	match state:
		states.idle:
			parent.lerp_vel(Vector2.ZERO, 0)
		states.run:
			parent.lerp_vel(dir, parent.MAX_SPEED)
			auto_flip()
		states.stealth,states.parry:
			parent.lerp_vel(dir, parent.SLOW_SPEED)
	parent.handle_movement()

func _unhandled_input(event):
	if event.is_action_pressed("stealth") and can_stealth():
		set_state(states.stealth)
	elif event.is_action_pressed("attack") and can_parry():
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

func _exit(old, _new):
	match old:
		states.idle:
			idle_time.stop()


func auto_flip():
	if dir.x != 0:
		parent.flipped = dir.x < 0


func can_stealth() -> bool:
	return [states.idle,states.run].has(state) and Player.mana > 0

func can_parry() -> bool:
	return [states.idle,states.run].has(state) and !parent.stealth


func _on_Sprite_animation_finished():
	parent.sprite.disconnect("animation_finished",self,"_on_Sprite_animation_finished")
	set_state(states.idle)

func wait_for_animation():
	parent.sprite.connect("animation_finished",self,"_on_Sprite_animation_finished")


func _on_ManaDecay_timeout():
	Player.health += 1
	Player.mana -= 1
	if Player.mana == 0 and parent.stealth and state != states.stealth:
		set_state(states.stealth)

func _on_ManaRegen_timeout():
	if Player.mana == Player.MAX_MANA:
		if parent.combat_duration.is_stopped():
			Player.health += 1
	else:
		Player.mana += 1

func _on_IdleTime_timeout():
	parent.animation = "idle_start"
