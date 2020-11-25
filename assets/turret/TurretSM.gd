extends StateMachine

var player : PhysicsBody2D

onready var sight = parent.get_node("Sight") as Area2D
onready var firerate = $FireRate

func _ready():
	add_state("scan")
	add_state("alert")
	add_state("death")
	init_state(states.scan)

func _state_logic(_delta):
	match state:
		states.alert:
			parent.angle = lerp_angle(parent.angle, angle_to_player(), 0.4)

func _transition(_delta):
	match state:
		states.scan:
			if sight.get_overlapping_bodies().size() > 0:
				player = sight.get_overlapping_bodies()[0]
				if parent.can_see(player):
					return states.alert
		states.alert:
			if sight.get_overlapping_bodies().size() == 0 or !parent.can_see(player):
				return states.scan

func _enter(new, _old):
	match new:
		states.scan:
			parent.scan_auto()
		states.alert:
			parent.alert_audio.play(0, player.global_position)
			firerate.start()

func _exit(old, _new):
	match old:
		states.scan:
			parent.scan_stop()
		states.alert:
			firerate.stop()
			parent.angle = fposmod(parent.angle - parent.central_angle + PI, 2 * PI) + \
					parent.central_angle - PI


func angle_to_player():
	return player.global_position.angle_to_point(parent.global_position)


func _on_Timer_timeout():
	parent.fire()


func _on_Turret_died():
	set_state(states.death)
