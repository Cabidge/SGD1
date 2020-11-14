extends StateMachine

var player : PhysicsBody2D

onready var sight = parent.get_node("Sight") as Area2D

func _ready():
	add_state("scan")
	add_state("alert")
	call_deferred("set_state", states.scan)

func _state_logic(delta):
	match state:
		states.alert:
			parent.angle = lerp_angle(parent.angle, angle_to_player(), 0.25)

func _transition(delta):
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

func _exit(old, _new):
	match old:
		states.scan:
			parent.scan_stop()


func angle_to_player():
	return parent.global_position.angle_to_point(player.global_position)
