extends "res://assets/projectiles/Projectile.gd"

const KNOCKBACK = 64

var spark_scene = load("res://assets/projectiles/bullet/BulletSpark.tscn")

var hit_info = HitInfo.new(2)

onready var light = $Light2D

func _physics_process(delta):
	handle_collision(delta)
	
	light.energy = lerp(light.energy, 0.4, 0.2)

func _on_Timer_timeout():
	call_deferred("free")


func _on_Bullet_collided(collision : KinematicCollision2D):
	var spark = spark_scene.instance()
	spark.position = position
	get_parent().add_child(spark)
	spark.emitting = true
	
	spark.look_at(collision.normal + spark.position)
	
	if collision.collider is Hurtbox:
		collision.collider.hit(hit_info)


func _on_Bullet_fired(vec):
	hit_info.knockback = vec * KNOCKBACK
