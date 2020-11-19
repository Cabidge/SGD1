extends "res://assets/projectiles/Projectile.gd"

var hit_info = HitInfo.new(2)

func _physics_process(delta):
	handle_collision(delta)

func _on_Orb_collided(collision):
	if collision.collider is Hurtbox:
		collision.collider.hit(hit_info)

func _on_Orb_fired(vec):
	position += vec * 12
