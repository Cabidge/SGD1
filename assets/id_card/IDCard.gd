extends Node2D

onready var interact_area = $InteractArea2D
onready var sprite = $Sprite

func _ready():
	interact_area.disabled = true
	var parent = get_parent()
	if parent.is_in_group("Guard"):
		parent.connect("died",self,"_on_Guard_died")


func _on_Guard_died():
	if interact_area.is_in_range():
		pick_up()
	else:
		sprite.position.y = -4
		interact_area.disabled = false
		$Shadow.visible = true
	
	position = get_parent().position
	
	var new_parent = get_parent().get_parent()
	get_parent().remove_child(self)
	new_parent.add_child(self)

func pick_up():
	sprite.visible = false
	$Timer.start()
	Player.has_id = true

func _on_InteractArea2D_interacted():
	pick_up()
	interact_area.disabled = true

func _on_Timer_timeout():
	call_deferred("free")
