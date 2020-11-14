extends Control

onready var vitals = $Vitals

func _ready():
	var err = Player.connect("updated_mana",self,"_on_Player_updated_mana")
	assert(err == OK)
	
	err = Player.connect("updated_health",self,"_on_Player_updated_health")
	assert(err == OK)
	
	err = Player.connect("updated_stealth",self,"_on_Player_updated_stealth")
	assert(err == OK)

func _on_Player_updated_stealth(stealth):
	vitals.update_stealth(stealth)

func _on_Player_updated_mana(mana):
	vitals.update_mana(mana)

func _on_Player_updated_health(health):
	vitals.update_health(health)
