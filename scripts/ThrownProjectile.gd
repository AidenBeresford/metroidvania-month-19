extends KinematicBody2D

var velocity = Vector2()


func _physics_process(delta):
	move_and_slide(velocity)


func throw(dir):
	velocity.x = 500*dir
	
	if velocity.x < 0:
		$AnimatedSprite.flip_h = true


func _on_Hitbox_body_entered(body):
	for bodies in $Hitbox.get_overlapping_bodies():
		
		if bodies.get_parent().name == "Player":
			bodies.knockback()
