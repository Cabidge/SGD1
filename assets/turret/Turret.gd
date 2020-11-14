extends Node2D

const SCAN_ANGLE = deg2rad(45)
const SCAN_TIME = 0.8

export var central_angle = 0.0

var bullet_scene = load("res://assets/projectiles/bullet/Bullet.tscn")

var angle := 0.0 setget set_angle

onready var sprite = $Sprite
onready var laser = $Laser

onready var tween = $Tween

func _ready():
	set_angle(central_angle)
	scan_auto()

func _input(event):
	if event.is_action_pressed("attack"):
		fire()


func scan_auto():
	if angle < central_angle:
		tween_angle(central_angle + SCAN_ANGLE)
	else:
		tween_angle(central_angle - SCAN_ANGLE)

func tween_angle(new_angle : float):
	var time = abs((angle - new_angle) / SCAN_ANGLE) * SCAN_TIME
	tween.interpolate_property(self,"angle",angle,new_angle,
			time)
	tween.start()

func _on_Tween_tween_all_completed():
	scan_auto()


func set_angle(new):
	angle = new
	
	sprite.angle = angle
	laser.angle = angle


func fire():
	var bullet = bullet_scene.instance()
	bullet.position = global_position + Vector2.LEFT.rotated(angle) * 8
	get_parent().add_child(bullet)
	bullet.fire_at_angle(angle)
	
	sprite.fire = true
	yield(get_tree().create_timer(0.1),"timeout")
	sprite.fire = false
