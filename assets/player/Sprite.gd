extends AnimatedSprite

func _on_Sprite_animation_finished():
	if animation == "idle_start":
		play("idle")
