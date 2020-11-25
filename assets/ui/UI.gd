extends Control

onready var vitals = $Vitals
onready var id_display_anim = $ID/AnimationPlayer

func _ready():
	var err = Player.connect("updated_mana",self,"_on_Player_updated_mana")
	assert(err == OK)
	
	err = Player.connect("updated_health",self,"_on_Player_updated_health")
	assert(err == OK)
	
	err = Player.connect("updated_stealth",self,"_on_Player_updated_stealth")
	assert(err == OK)
	
	err = Player.connect("updated_id",self,"_on_Player_updated_id")
	assert(err == OK)

func reset_all():
	vitals.reset_portrait()
	vitals.reset_mana()
	vitals.reset_health()
	
	id_display_anim.play_backwards("Show")
	id_display_anim.seek(0)

func _on_Player_updated_stealth(stealth):
	vitals.update_stealth(stealth)

func _on_Player_updated_mana(mana):
	vitals.update_mana(mana)

func _on_Player_updated_health(health):
	vitals.update_health(health)

func _on_Player_updated_id(has_id):
	if has_id:
		id_display_anim.play("Show")
	else:
		id_display_anim.play_backwards("Show")
