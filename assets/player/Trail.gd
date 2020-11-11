extends Node2D

var trail_length := 0.0

onready var anim_player = $AnimationPlayer
onready var tween = $Tween
onready var line = $Line2D
onready var trail_head = $TrailPivot/TrailHead

func _ready():
	set_physics_process(false)

func _physics_process(delta):
	line.add_point(trail_head.global_position - global_position)
	while line.points.size() > trail_length:
		line.remove_point(0)

func play_swipe():
	anim_player.play("Swipe")
	
	tween.interpolate_property(self,"trail_length",20.0,0,0.4,Tween.TRANS_QUAD,Tween.EASE_OUT)
	tween.start()
	
	set_physics_process(true)
