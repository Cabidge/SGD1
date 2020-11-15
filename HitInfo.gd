class_name HitInfo
extends Object

var damage : int
var dealer

func _init(Damage : int = 1, Dealer = null):
	self.damage = Damage
	self.dealer = Dealer
