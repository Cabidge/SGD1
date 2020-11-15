extends Node

signal updated_health(new)
signal updated_mana(new)
signal updated_stealth(new)

const MAX_HEALTH = 16
const MAX_MANA = 10

var health := MAX_HEALTH setget set_health
var mana := MAX_MANA setget set_mana

func set_health(new : int):
	new = int(clamp(new,0,MAX_HEALTH))
	if new != health:
		health = new
		emit_signal("updated_health",health)

func set_mana(new : int):
	new = int(clamp(new,0,MAX_MANA))
	if new != mana:
		mana = new
		emit_signal("updated_mana",mana)

func update_stealth(stealth):
	emit_signal("updated_stealth",stealth)
