class_name HitInfo
extends Object

var damage : int
var knockback : Vector2
var dealer

func _init(Damage : int = 1, Knockback : Vector2 = Vector2.ZERO, Dealer = null):
	self.damage = Damage
	self.knockback = Knockback
	self.dealer = Dealer
