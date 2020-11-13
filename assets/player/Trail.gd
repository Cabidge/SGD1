extends Node2D

var trail_length := 0

onready var anim_player = $AnimationPlayer
onready var tween = $Tween
onready var line = $Line2D
onready var trail_head = $TrailPivot/TrailHead

func _ready():
	set_physics_process(false)

func _physics_process(_delta):
	var point_pos = (trail_head.global_position - global_position).rotated(-global_rotation)
	line.add_point(point_pos)
	while line.points.size() > trail_length:
		line.remove_point(0)

func play_swipe():
	if get_global_mouse_position().x < global_position.x:
		anim_player.play_backwards("Swipe")
	else:
		anim_player.play("Swipe")
	
	tween.stop_all()
	tween.interpolate_property(self,"trail_length", 15, 0, 0.4, Tween.TRANS_QUAD,Tween.EASE_OUT)
	tween.start()
	
	set_physics_process(true)

func _on_Tween_tween_all_completed():
	set_physics_process(false)
