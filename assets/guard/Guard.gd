extends PatrolCharacter2D

signal died

const MAX_SPEED = Global.TILE * 3

var flipped = false setget set_flipped
var angle := 0.0 setget set_angle, get_angle

var health := 10

var alert_pos : Vector2 = position
var player_last_seen : Vector2 = position

var orb_scene = load("res://assets/projectiles/orb/Orb.tscn")

onready var sprite = $Sprite
onready var anim_player = $AnimationPlayer

onready var stab_range_collision = $StabRange/CollisionShape2D
onready var hurtbox_collision = $Hurtbox/CollisionShape2D

onready var state_machine = $StateMachine as StateMachine

onready var pivot = $Pivot
onready var sight = pivot.get_node("Sight")
onready var los = $LineOfSight

func _physics_process(_delta):
	# debug line
	$Line2D.points = path
	$Line2D.global_position = Vector2.ZERO

func lerp_sight(to_angle : float, weight = 0.04):
	pivot.rotation = lerp_angle(pivot.rotation,to_angle,weight)

func set_flipped(new):
	flipped = new
	sprite.flip_h = flipped

func set_angle(new):
	angle = new

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


func _on_Hurtbox_hit(info : HitInfo):
	damage(info.damage)
	sprite.modulate = Color.white * 20
	
	velocity += info.knockback

func _on_Hurtbox_recovered():
	sprite.modulate = Color.white


func player_in_sight() -> bool:
	var bodies = sight.get_overlapping_bodies()
	if bodies.size() == 0:
		return false
	
	var player = bodies[0]
	var player_pos = player.global_position
	los.cast_to = player_pos - position
	los.force_raycast_update()
	
	if los.get_collider() == player:
		player_last_seen = player_pos
		return true
	return false


func fire_orb():
	var orb = orb_scene.instance()
	get_parent().add_child(orb)
	orb.position = position + Vector2.UP * 14
	orb.fire_at(player_last_seen)
