extends CanvasLayer

onready var mana = $Control/Mana

func _ready():
	var err = Player.connect("updated_mana",self,"_on_Player_updated_mana")
	assert(err == OK)

func _on_Player_updated_mana(new):
	mana.text = "Mana: " + str(new)
