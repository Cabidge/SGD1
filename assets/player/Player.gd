extends Character2D

signal died
signal stalled

const MAX_SPEED = Global.TILE * 5 # tiles per second
const SLOW_SPEED = MAX_SPEED * 0.1

var stealth = false

var flipped = false setget set_flipped
var animation : String setget set_animation

var stab_info = HitInfo.new(9999, Vector2.ZERO, self)
var target

onready var sprite = $Sprite
onready var pivot = $Pivot
onready var light = $Light2D

onready var camera = $Camera2D

onready var transition_player = $TransitionPlayer

onready var stab_detector = $StabDetector
onready var stab_detector_collision = $StabDetector/CollisionShape2D
onready var hurtbox_collision = $Body/CollisionShape2D
onready var sight_collision = $SightBox/CollisionShape2D

onready var combat_duration = $CombatDuration
onready var parry_cooldown = $ParryCooldown
onready var timeout = $Timeout

onready var stealth_audio = $StealthAudio
onready var stab_audio = $StabAudio
onready var rustle_audio = $RustleAudio

onready var auto_footsteps = $AutoFootsteps

func _ready():
	auto_footsteps.sprite = sprite

func handle_movement():
	.handle_movement()
	camera.align()

func move_dir() -> Vector2:
	var x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x,y).normalized()


func set_flipped(new):
	flipped = new
	sprite.flip_h = flipped

func set_animation(anim : String):
	if anim == "parry":
		sprite.offset.x = -Global.negative_bool(flipped) * 4
	else :
		sprite.offset.x = 0
	
	animation = anim
	if stealth:
		animation += "_stealth"
	
	sprite.play(animation)


func toggle_stealth():
	stealth_audio.play()
	
	stealth = !stealth
	sprite.play("transition",!stealth)
	
	if stealth:
		transition_player.play("Transition")
	else:
		transition_player.play_backwards("Transition")
	
	Player.update_stealth(stealth)


func parry():
	rustle_audio.play()
	set_flipped(get_global_mouse_position().x < position.x)
	set_animation("parry")
	pivot.swipe()
	
	parry_cooldown.start()


func damage(amount : int = 1):
	if amount <= 0:
		return
	
	Player.health -= amount
	if Player.health <= 0:
		stealth = false
		
		transition_player.play("Death")
		
		camera.zoom_in(1)
		
		stab_detector_collision.set_deferred("disabled",true)
		hurtbox_collision.set_deferred("disabled",true)
		sight_collision.set_deferred("disabled",true)
		
		emit_signal("died")

func _on_Body_hit(info : HitInfo):
	damage(info.damage)
	sprite.modulate = Color.white * 20
	combat_duration.start()
	
	velocity += info.knockback

func _on_Body_recovered():
	sprite.modulate = Color.white


func stab_begin(a_target):
	rustle_audio.play()
	
	target = a_target
	
	set_animation("stab")
	transition_player.play("Stab")

func stab_target():
	if target:
		stab_audio.play()
		if target.hurtbox:
			target.hurtbox.hit(stab_info)
		Player.mana += target.mana_count

func get_stab_target():
	return stab_detector.target


func _on_DeflectHitbox_body_entered(body):
	body.deflect(pivot.rotation)


func delete():
	sprite.visible = false
	$Shadow.visible = false
	transition_player.play_backwards("LightFade")
	
	emit_signal("stalled")
	
	camera.current = false
	
	timeout.start()

func _on_Timeout_timeout():
	call_deferred("free")
