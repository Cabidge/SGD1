extends "res://assets/projectiles/Projectile.gd"

const KNOCKBACK = 128
const SENSE_ANGLE = PI/3 * 2 # PI = full 360 fov

var hit_info = HitInfo.new(8)

var deflected = false

onready var sprite = $AnimatedSprite
onready var deflect_audio = $DeflectAudio

onready var area = $Area2D

func _physics_process(delta):
	home_toward_targets()
	handle_collision(delta)

func _on_Orb_collided(collision):
	if collision.collider is Hurtbox:
		hit_info.knockback = velocity.normalized() * KNOCKBACK
		collision.collider.hit(hit_info)

func _on_Orb_fired(vec):
	position += vec * 8


func deflect(angle):
	if deflected:
		return
	deflected = true
	
	deflect_audio.play()
	
	fire_at_angle(angle)
	
	# tweak collisions
	set_collision_layer_bit(7, false) # turn off layer
	set_collision_mask_bit(5, false) # turn off player collision
	set_collision_mask_bit(6, true) # turn on enemy collision
	
	# swap area mask as well
	area.set_collision_mask_bit(5, false)
	area.set_collision_mask_bit(6, true)


func home_toward_targets():
	var bodies = area.get_overlapping_bodies()
	if bodies.size() > 0:
		for body in bodies:
			var vec = body.global_position - global_position
			if abs(vec.angle_to(velocity)) <= SENSE_ANGLE:
				vec = vec.normalized()
				velocity = velocity.linear_interpolate(vec * speed, 0.05)
	else:
		velocity = velocity.linear_interpolate(velocity.normalized() * speed, 0.2)
