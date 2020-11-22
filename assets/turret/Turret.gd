extends Node2D

signal died

const SCAN_ANGLE = deg2rad(45)
const SCAN_TIME = 0.8

export(float,-180,180) var starting_angle = 0
onready var central_angle = deg2rad(starting_angle)

var bullet_scene = load("res://assets/projectiles/bullet/Bullet.tscn")

var angle := 0.0 setget set_angle

var scanning = false

var player : KinematicBody

var health := 2

onready var sprite = $Sprite
onready var laser = $Laser
onready var sight = $Sight

onready var tween = $Tween

onready var los = $LineOfSight

onready var beep_audio = $BeepAudio
onready var alert_audio = $AlertAudio
onready var shoot_audio = $ShootAudio

func _ready():
	set_angle(central_angle)


func scan_auto():
	scanning = true
	if angle < central_angle:
		tween_angle(central_angle + SCAN_ANGLE)
	else:
		tween_angle(central_angle - SCAN_ANGLE)

func scan_stop():
	scanning = false
	tween.remove_all()

func tween_angle(new_angle : float):
	var time = abs((angle - new_angle) / SCAN_ANGLE) * SCAN_TIME
	tween.interpolate_property(self,"angle",angle,new_angle,
			time)
	tween.start()

func _on_Tween_tween_all_completed():
	if scanning:
		beep_audio.play()
		scan_auto()


func set_angle(new):
	angle = new
	
	sprite.angle = angle
	laser.angle = angle
	sight.rotation = angle


func fire():
	shoot_audio.play()
	
	var bullet = bullet_scene.instance()
	bullet.position = global_position
	get_parent().add_child(bullet)
	bullet.fire_at_angle(angle + rand_range(-0.1,0.1))
	
	sprite.fire = true
	yield(get_tree().create_timer(0.1),"timeout")
	sprite.fire = false


func can_see(body : PhysicsBody2D):
	los.cast_to = body.global_position - global_position
	los.force_raycast_update()
	if los.is_colliding():
		return los.get_collider() == body
	return false


func damage(amount : int = 1):
	if amount <= 0:
		return
	
	health -= amount
	if health <= 0:
		emit_signal("died")
		laser.disabled = true
		sprite.frame = 10

func _on_Hurtbox_hit(info : HitInfo):
	damage(info.damage)
	sprite.modulate = Color.white * 20

func _on_Hurtbox_recovered():
	sprite.modulate = Color.white
