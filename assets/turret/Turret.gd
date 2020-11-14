extends Node2D

const SCAN_ANGLE = deg2rad(45)
const SCAN_TIME = 0.8

export var central_angle = 0.0

var bullet_scene = load("res://assets/projectiles/bullet/Bullet.tscn")

var angle := 0.0 setget set_angle

var scanning = false

var player : KinematicBody

onready var sprite = $Sprite
onready var laser = $Laser
onready var sight = $Sight

onready var tween = $Tween

onready var los = $LineOfSight

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
		scan_auto()


func set_angle(new):
	angle = new
	
	sprite.angle = angle
	laser.angle = angle
	sight.rotation = angle + PI


func fire():
	var bullet = bullet_scene.instance()
	bullet.position = global_position + Vector2.UP * 2
	get_parent().add_child(bullet)
	bullet.fire_at_angle(angle)
	
	sprite.fire = true
	yield(get_tree().create_timer(0.1),"timeout")
	sprite.fire = false


func can_see(body : PhysicsBody2D):
	los.cast_to = body.global_position - los.global_position
	los.force_raycast_update()
	if los.is_colliding():
		return los.get_collider() == body
	return false
