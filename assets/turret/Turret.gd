extends Node2D

const SCAN_ANGLE = 0.2
const SCAN_TIME = 0.8

export var central_angle = 0.0

var angle := 0.0 setget set_angle

onready var sprite = $Sprite
onready var laser = $Laser

onready var tween = $Tween

func _ready():
	scan_auto()

func scan_auto():
	if angle < central_angle:
		tween_angle(central_angle + SCAN_ANGLE)
	else:
		tween_angle(central_angle - SCAN_ANGLE)

func tween_angle(angle_diff : float):
	tween.interpolate_property(self,"angle",angle,angle + angle_diff,
			SCAN_TIME, Tween.TRANS_SINE,Tween.EASE_IN_OUT)
	tween.start()

func set_angle(new):
	angle = new
	
	sprite.angle = angle
	laser.angle = angle

func _on_Tween_tween_all_completed():
	scan_auto()
