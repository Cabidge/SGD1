extends Node2D

const SCAN_ANGLE = deg2rad(45)
const SCAN_TIME = 1.0

export var central_angle = 0.0

var angle := 0.0 setget set_angle

onready var sprite = $Sprite
onready var laser = $Laser

onready var tween = $Tween

func _ready():
	set_angle(central_angle)
	scan_auto()

func scan_auto():
	print(angle)
	if angle < central_angle:
		tween_angle(central_angle + SCAN_ANGLE)
	else:
		tween_angle(central_angle - SCAN_ANGLE)

func tween_angle(new_angle : float):
	var time = abs((angle - new_angle) / SCAN_ANGLE) * SCAN_TIME
	tween.interpolate_property(self,"angle",angle,new_angle,
			time)
	tween.start()

func set_angle(new):
	angle = new
	
	sprite.angle = angle
	laser.angle = angle

func _on_Tween_tween_all_completed():
	scan_auto()
