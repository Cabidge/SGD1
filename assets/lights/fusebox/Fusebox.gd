extends Node2D

export(NodePath) var light_group_path

var destroyed = false setget set_destroyed

onready var opened_sprite = $Sprite/SpriteOpen
onready var interact_area = $InteractArea2D

func set_destroyed(new):
	destroyed = new
	opened_sprite.visible = destroyed


func _on_InteractArea2D_interacted():
	destroy()

func destroy():
	set_destroyed(true)
	interact_area.set_deferred("disabled",true)
	
	get_node(light_group_path).disable()
