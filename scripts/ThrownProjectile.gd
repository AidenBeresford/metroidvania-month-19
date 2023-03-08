extends KinematicBody2D

var velocity = Vector2()


func _physics_process(delta):
	move_and_slide(velocity)


func throw(dir):
	velocity.x = 100*dir
	
	if velocity.x < 0:
		$AnimatedSprite.flip_h = true
