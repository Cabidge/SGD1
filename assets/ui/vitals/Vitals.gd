extends Control

onready var portrait_anim = $Portrait/AnimationPlayer

func _ready():
	Player.connect("updated_stealth",self,"_on_Player_updated_stealth")

func _on_Player_updated_stealth(stealth):
	if stealth:
		portrait_anim.play("Transition")
	else:
		portrait_anim.play_backwards("Transition")
