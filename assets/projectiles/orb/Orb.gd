extends "res://assets/projectiles/Projectile.gd"

const KNOCKBACK = 128

var hit_info = HitInfo.new(2)

onready var sprite = $AnimatedSprite

func _physics_process(delta):
	handle_collision(delta)

func _on_Orb_collided(collision):
	if collision.collider is Hurtbox:
		collision.collider.hit(hit_info)

func _on_Orb_fired(vec):
	position += vec * 8
	hit_info.knockback = vec * KNOCKBACK


func deflect(angle):
	fire_at_angle(angle)
	
	# tweak collisions
	set_collision_layer_bit(7, false) # turn off layer
	set_collision_mask_bit(5, false) # turn off player collision
	set_collision_mask_bit(6, true) # turn on enemy collision
