extends Node2D

signal player_entered

onready var elevator = $Elevator
onready var player_tween_timer = $PlayerTweenTimer

onready var ding_audio = $DingAudio

func _on_PlayerDetector_body_entered(body):
	if !body.stealth and Player.has_id:
		Player.has_id = false
		
		elevator.tween_player_sprite(body.sprite)
		elevator.enable_camera = true
		
		body.delete()
		
		player_tween_timer.start()
		
		ding_audio.play()


func _on_PlayerTweenTimer_timeout():
	emit_signal("player_entered")
	
	elevator.close_door()
	yield(get_tree().create_timer(0.6),"timeout")
	elevator.cabin_mid_up()
