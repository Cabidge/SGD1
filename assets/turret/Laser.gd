extends Line2D

export var length := 100.0

var angle := 0.0 setget set_angle

onready var raycast = $RayCast2D
onready var point = $Point

func _ready():
	for _i in 2:
		add_point(Vector2.ZERO)

func _physics_process(_delta):
	var p = raycast.cast_to
	raycast.force_raycast_update()
	
	if raycast.is_colliding():
		p = raycast.get_collision_point() - global_position
		point.position = p
	point.visible = raycast.is_colliding()
	
	set_point_position(1, p)

func set_angle(new):
	angle = new
	raycast.cast_to = (Vector2.LEFT * length).rotated(angle)
	set_point_position(0, raycast.cast_to * 0.1)
