extends PatrolCharacter2D

signal died

const MAX_SPEED = Global.TILE * 3

export(float,-180.0,180.0) var start_angle = 0.0
export(Color) var calm_color
export(Color) var sus_color
export(Color) var alert_color

var flipped = false setget set_flipped
var angle := 0.0 setget set_angle, get_angle

var health := 10

var alert_level := 0 setget set_alert_level
var current_alert := 0

var alert_pos : Vector2 = Vector2.ZERO
var player_last_seen : Vector2 = position
var previous_last_seen : Vector2 = position

var orb_scene = load("res://assets/projectiles/orb/Orb.tscn")

onready var sprite = $Sprite
onready var anim_player = $AnimationPlayer

onready var stab_range_collision = $StabRange/CollisionShape2D
onready var hurtbox_collision = $Hurtbox/CollisionShape2D

onready var state_machine = $StateMachine as StateMachine

onready var pivot = $Pivot
onready var sight = pivot.get_node("Sight")
onready var los = $LineOfSight

onready var death_audio = $DeathAudio
onready var grunt_audio = $GruntAudio
onready var alert_audio = $AlertAudio

onready var charge_audio = $OrbChargeAudio
onready var fire_audio = $OrbFireAudio

func _ready():
	pivot.light.color = calm_color
	
	set_angle(deg2rad(start_angle))
	sprite.flip_h = abs(start_angle) < 90

func _physics_process(_delta):
	# debug line
	$Line2D.points = path
	$Line2D.global_position = Vector2.ZERO

func lerp_sight(to_angle : float, weight = get_alert_weight()):
	pivot.rotation = lerp_angle(pivot.rotation,to_angle,weight)

func get_alert_weight() -> float:
	return 0.04 + alert_level * 0.03


func set_flipped(new):
	flipped = new
	sprite.flip_h = flipped

func set_angle(new):
	pivot.rotation = new

func get_angle():
	return pivot.rotation


func damage(amount : int = 1):
	if amount <= 0:
		return
	
	health -= amount
	if health <= 0:
		emit_signal("died")
		stab_range_collision.set_deferred("disabled", true)
		hurtbox_collision.set_deferred("disabled", true)
		
		death_audio.play()
	else:
		grunt_audio.play()


func _on_Hurtbox_hit(info : HitInfo):
	damage(info.damage)
	sprite.modulate = Color.white * 20
	
	velocity += info.knockback

func _on_Hurtbox_recovered():
	sprite.modulate = Color.white


func player_in_sight() -> bool:
	previous_last_seen = player_last_seen
	
	var bodies = sight.get_overlapping_bodies()
	if bodies.size() == 0:
		return false
	
	var player = bodies[0]
	var player_pos = player.global_position
	los.cast_to = player_pos - position
	los.force_raycast_update()
	
	if los.get_collider() != player:
		return false
	
	player_last_seen = player_pos
	return true

func extend_player_seen():
	player_last_seen = player_last_seen.linear_interpolate(previous_last_seen,-60)
	previous_last_seen = player_last_seen


func fire_orb():
	fire_audio.play()
	
	var orb = orb_scene.instance()
	get_parent().add_child(orb)
	orb.position = position + Vector2.UP * 14
	orb.fire_at(player_last_seen)


func set_alert_level(new):
	alert_level = int(clamp(new,0,4))
	current_alert = alert_level
	var color : Color
	match alert_level:
		0: color = calm_color
		1,2: color = sus_color
		3,4: color = alert_color
	pivot.tween_light(color)
