class_name Hurtbox
extends StaticBody2D

signal hit(info)
signal recovered()

var timer : Timer
var disabled = false

func _ready():
	add_to_group("Hurtbox")
	
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.1
	timer.one_shot = true
	timer.connect("timeout",self,"_on_Timer_timeout")

func hit(info : HitInfo):
	if disabled: return
	
	emit_signal("hit",info)
	
	disabled = true
	timer.start()

func _on_Timer_timeout():
	emit_signal("recovered")
	disabled = false
